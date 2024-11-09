import Toybox.Graphics;
import Toybox.Lang;
import MathUtils;
import EquationUtils;

class AltitudeSaturationGraph {

    var paddingX as Lang.Number;
    var paddingTop as Lang.Number;
    var paddingBottom as Lang.Number;

    var currentAltitude as Lang.Number or Lang.Float;
    var currentSaturation as Lang.Number or Lang.Float;

    var width as Lang.Number;
    var height as Lang.Number;

    var topLeft as Point;
    var topRight as Point;
    var bottomLeft as Point;
    var bottomRight as Point;

    var canvasWidth as Lang.Number;
    var canvasHeight as Lang.Number; 

    var altitudeWindow as Lang.Number;

    var markerSize as Lang.Number;

    var showBestSaturation as Lang.Boolean;
    var showWorstSaturation as Lang.Boolean;

    var sensorHistory as CircularBufferIterator;

    function initialize(options as {
        :width as Lang.Number,
        :height as Lang.Number,
        :paddingX as Lang.Number,
        :paddingTop as Lang.Number,
        :paddingBottom as Lang.Number,
        :currentAltitude as Lang.Number,
        :currentSaturation as Lang.Float,
        :altitudeWindow as Lang.Number,
        :markerSize as Lang.Number,
        :showBestSaturation as Lang.Boolean,
        :showWorstSaturation as Lang.Boolean,
        :sensorHistory as CircularBufferIterator
    }) {
        width = options.get(:width);
        height = options.get(:height);
        paddingX = options.get(:paddingX);
        paddingTop = options.get(:paddingTop);
        paddingBottom = options.get(:paddingBottom);
        currentAltitude = options.get(:currentAltitude);
        currentSaturation = options.get(:currentSaturation);
        altitudeWindow = options.get(:altitudeWindow);
        markerSize = options.get(:markerSize);
        showBestSaturation = options.get(:showBestSaturation);
        showWorstSaturation = options.get(:showWorstSaturation);
        sensorHistory = options.get(:sensorHistory);

        topLeft = new Point(paddingX, paddingTop);
        topRight = new Point(width - paddingX, paddingTop);
        bottomLeft = new Point(paddingX, height - paddingBottom);
        bottomRight = new Point(width - paddingX, height - paddingBottom);
        
        canvasWidth = topRight.x - topLeft.x - 2;
        canvasHeight = bottomRight.y - topRight.y; 
    }

    function draw(dc as Dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        drawBorders(dc);

        var xValues = [];
        var yValues = [];

        while (sensorHistory.hasMore()) {
            var current = sensorHistory.getNext();

            xValues.add(current.altitude);
            yValues.add(current.saturation);
        }
        
        var regression = linearRegression(xValues, yValues);
        var slope = regression.get(:slope);
        var intercept = regression.get(:intercept);

        var confidence = confidenceInterval(xValues, yValues, slope, intercept);
        var slopeLower = confidence.get(:slopeConfidenceInterval).get(:lower);
        var slopeUpper = confidence.get(:slopeConfidenceInterval).get(:upper);
        var interceptLower = confidence.get(:interceptConfidenceInterval).get(:lower);
        var interceptUpper = confidence.get(:interceptConfidenceInterval).get(:upper);

        var minAltitude = MathUtils.max(currentAltitude - altitudeWindow, 0);
        var maxAltitude = currentAltitude + altitudeWindow;

        var maxSaturation = getMaxSaturation(minAltitude);
        var minSaturation = maxSaturation - 20;

        var altitudeScale = (maxAltitude - minAltitude) / canvasWidth;
        var saturationScale = canvasHeight / (maxSaturation - minSaturation);

        var currentPoint = getCurrentPoint(minAltitude, altitudeScale, saturationScale);

        var scrollY = 0;

        for (var canvasX = 0; canvasX <= canvasWidth; canvasX++) {
            var altitude = minAltitude + canvasX * altitudeScale;
            var theoreticalSaturation = EquationUtils.getPolynomialTheoreticalSaturation(altitude);

            theoreticalSaturation = MathUtils.clamp(theoreticalSaturation, minSaturation, maxSaturation);

            var bestPossibleSaturation = theoreticalSaturation * 1.05;
            var worstPossibleSaturation = theoreticalSaturation * 0.95;

            if (currentPoint.y > topLeft.y + canvasHeight / 2) {
                scrollY = currentPoint.y - (topLeft.y + canvasHeight / 2);
            }

            var graphX = canvasX + topLeft.x + 1;
            var bestGraphY = (topLeft.y + saturationScale * (100 - bestPossibleSaturation) + 1) - scrollY;
            var graphY = (topLeft.y + saturationScale * (100 - theoreticalSaturation) + 1) - scrollY;
            var worstGraphY = (topLeft.y + saturationScale * (100 - worstPossibleSaturation) + 1) - scrollY;

            var bestNewPoint = new Point(graphX, bestGraphY);
            var newPoint = new Point(graphX, graphY);
            var worstNewPoint = new Point(graphX, worstGraphY);

            dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_BLACK);
            if (MathUtils.isInRectangle(topLeft, bottomRight, bestNewPoint) && showBestSaturation) {
                dc.drawPoint(bestNewPoint.x, bestNewPoint.y);
            }
            if (MathUtils.isInRectangle(topLeft, bottomRight, worstNewPoint) && showWorstSaturation) {
                dc.drawPoint(worstNewPoint.x, worstNewPoint.y);
            }

            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
            if (MathUtils.isInRectangle(topLeft, bottomRight, newPoint)) {
                dc.drawPoint(newPoint.x, newPoint.y);
            }
        }

        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_BLACK);
        for (var canvasX = 0; canvasX <= canvasWidth; canvasX++) {
            var altitude = minAltitude + canvasX * altitudeScale;

            var upperSaturation = slopeUpper * altitude + interceptUpper;
            upperSaturation = MathUtils.clamp(upperSaturation, minSaturation, maxSaturation);

            var graphX = canvasX + topLeft.x + 1;
            var upperGraphY = topLeft.y + saturationScale * (100 - upperSaturation) + 1;
            upperGraphY -= scrollY;

            var upperPoint = new Point(graphX, upperGraphY);
            if (MathUtils.isInRectangle(topLeft, bottomRight, upperPoint)) {
                dc.drawPoint(upperPoint.x, upperPoint.y);
            }

            var lowerSaturation = slopeLower * altitude + interceptLower;
            lowerSaturation = MathUtils.clamp(lowerSaturation, minSaturation, maxSaturation);

            var lowerGraphY = topLeft.y + saturationScale * (100 - lowerSaturation) + 1;
            lowerGraphY -= scrollY;

            var lowerPoint = new Point(graphX, lowerGraphY);
            if (MathUtils.isInRectangle(topLeft, bottomRight, lowerPoint)) {
                dc.drawPoint(lowerPoint.x, lowerPoint.y);
            }
        }

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        for (var canvasX = 0; canvasX <= canvasWidth; canvasX++) {
            var altitude = minAltitude + canvasX * altitudeScale;
            var predictedSaturation = slope * altitude + intercept;

            predictedSaturation = MathUtils.clamp(predictedSaturation, minSaturation, maxSaturation);

            var graphX = canvasX + topLeft.x + 1;
            var graphY = topLeft.y + saturationScale * (100 - predictedSaturation) + 1;
            graphY -= scrollY; 

            var regressionPoint = new Point(graphX, graphY);

            if (MathUtils.isInRectangle(topLeft, bottomRight, regressionPoint)) {
                dc.drawPoint(regressionPoint.x, regressionPoint.y);
            }
        }

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        drawMarker(dc, currentPoint, scrollY);
        drawAltitude(dc, currentPoint, scrollY);
    }

    private function linearRegression(xValues, yValues) {
        var n = xValues.size();
        var xMean = 0;
        if (xValues.size() > 0) {
            xMean = Math.mean(xValues);
        }
        var yMean = 0;
        if (yValues.size() > 0) {
            yMean = Math.mean(yValues);
        }

        var numerator = 0.0;
        var denominator = 0.0;
        for (var i = 0; i < n; i++) {
            numerator += (xValues[i] - xMean) * (yValues[i] - yMean);
            denominator += (xValues[i] - xMean) * (xValues[i] - xMean);
        }

        if (denominator == 0) {
            denominator = 1;
        }

        var slope = numerator / denominator;

        var intercept = yMean - slope * xMean;

        return {
            :slope=>slope,
            :intercept=>intercept
        };
    }

    private function standardErrorSlope(xValues, yValues, slope, intercept) {
        var n = xValues.size();
        var residualsSum = 0.0;

        var xMean = 0;
        if (xValues.size() > 0) {
            xMean = Math.mean(xValues);
        }

        for (var i = 0; i < n; i++) {
            var predictedY = slope * xValues[i] + intercept;
            residualsSum += (yValues[i] - predictedY) * (yValues[i] - predictedY);
        }

        var residualVariance = residualsSum / (n - 2);
        var denominator = 0.0;
        for (var i = 0; i < n; i++) {
            denominator += (xValues[i] - xMean) * (xValues[i] - xMean);
        }

        if (denominator == 0) {
            denominator = 1;
        }

        var standardError = Math.sqrt(residualVariance / denominator);
        return standardError;
    }

    private function confidenceInterval(xValues, yValues, slope, intercept) {
        var n = xValues.size();
        if (n == 0) {
            n = 1;
        }
        var standardErrorSlope = standardErrorSlope(xValues, yValues, slope, intercept);

        var tValue = calculateTValue(n - 2);

        var slopeLower = slope - tValue * standardErrorSlope;
        var slopeUpper = slope + tValue * standardErrorSlope;

        var sum = 0;
        if (xValues.size() > 0) {
            sum = MathUtils.sum(xValues);
        }
        var standardErrorIntercept = standardErrorSlope * Math.sqrt(sum / n);
        var interceptLower = intercept - tValue * standardErrorIntercept;
        var interceptUpper = intercept + tValue * standardErrorIntercept;

        return {
            :slopeConfidenceInterval=>{
                :lower=>slopeLower,
                :upper=>slopeUpper
            },
            :interceptConfidenceInterval=>{
                :lower=>interceptLower,
                :upper=>interceptUpper
            }
        };  
    }

    private function calculateTValue(df as Lang.Number) as Lang.Number {
        if (df > 30) {
            return 1.96;
        }

        var tValue = 0.0;

        var tTable = {};
        tTable[1] = 12.706;
        tTable[2] = 4.303;
        tTable[3] = 3.182;
        tTable[4] = 2.776;
        tTable[5] = 2.571;
        tTable[6] = 2.447;
        tTable[7] = 2.365;
        tTable[8] = 2.306;
        tTable[9] = 2.262;
        tTable[10] = 2.228;
        tTable[11] = 2.201;
        tTable[12] = 2.179;
        tTable[13] = 2.160;
        tTable[14] = 2.145;
        tTable[15] = 2.131;
        tTable[16] = 2.120;
        tTable[17] = 2.110;
        tTable[18] = 2.101;
        tTable[19] = 2.093;
        tTable[20] = 2.086;
        tTable[21] = 2.080;
        tTable[22] = 2.074;
        tTable[23] = 2.069;
        tTable[24] = 2.064;
        tTable[25] = 2.060;
        tTable[26] = 2.056;
        tTable[27] = 2.052;
        tTable[28] = 2.048;
        tTable[29] = 2.045;
        tTable[30] = 2.042;

        if (tTable.hasKey(df)) {
            tValue = tTable.get(df);
        } else {
            tValue = 1.96;  // Approximate
        }

        return tValue;
    }

    private function drawAltitude(
        dc as Dc,
        currentPoint as Point,
        scrollY as Lang.Number
    ) as Void {
        var altitudeFormat = "($1$m)";
        var roundedAltitude = Math.round(currentAltitude).toNumber();
        dc.drawText(
            currentPoint.x, 
            currentPoint.y + 4 + markerSize - scrollY, 
            Graphics.FONT_XTINY,
            Lang.format(altitudeFormat, [roundedAltitude]), 
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    private function drawBorders(
        dc as Dc
    ) as Void {
        dc.drawLine(topLeft.x, topLeft.y, topRight.x, topRight.y);
        dc.drawLine(bottomLeft.x, bottomLeft.y, bottomRight.x, bottomRight.y);
        dc.drawLine(topLeft.x, topLeft.y, bottomLeft.x, bottomLeft.y); 
        dc.drawLine(topRight.x, topRight.y, bottomRight.x, bottomRight.y); 
    }

    private function drawMarker(
        dc as Dc, 
        point as Point,
        scrollY as Lang.Number or Lang.Float
    ) as Void {
        dc.drawLine(point.x - markerSize, point.y - markerSize - scrollY, point.x + markerSize, point.y + markerSize - scrollY);
        dc.drawLine(point.x + markerSize, point.y - markerSize - scrollY, point.x - markerSize, point.y + markerSize - scrollY);
    }

    private function getMinSaturation(
        maxAltitude as Lang.Number or Lang.Float
    ) as Lang.Number or Lang.Float {
        return getSaturation(maxAltitude, 0.90);
    }

    private function getMaxSaturation(
        minAltitude as Lang.Number or Lang.Float
    ) as Lang.Number or Lang.Float {
        return getSaturation(minAltitude, 1.10);
    }

    private function getSaturation(
        altitude as Lang.Number or Lang.Float,
        scale as Lang.Number or Lang.Float
    ) as Lang.Number or Lang.Float {
        var saturation = EquationUtils.getLinearTheoreticalSaturation(altitude) * scale;
        saturation = MathUtils.clamp(saturation, 0, 100);
        return saturation;
    }

    private function getCurrentPoint(
        minAltitude as Lang.Number or Lang.Float,
        altitudeScale as Lang.Number or Lang.Float,
        saturationScale as Lang.Number or Lang.Float
    ) as Point {
        if (altitudeScale == 0) {
            altitudeScale = 1;
        }
        var scaledAltitude = (currentAltitude - minAltitude) / altitudeScale; 
        var currentX = scaledAltitude + topLeft.x + 1;
        var currentY = topLeft.y + saturationScale * (100 - currentSaturation) + 1;
        currentY = MathUtils.clamp(currentY, topLeft.y, bottomLeft.y);
        var currentPoint = new Point(currentX, currentY);
        return currentPoint;
    }

}
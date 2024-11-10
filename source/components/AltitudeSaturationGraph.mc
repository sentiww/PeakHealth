import Toybox.Graphics;
import Toybox.Lang;
import MathUtils;
import EquationUtils;

public class AltitudeSaturationGraph {

    private var _paddingX as Number;
    private var _paddingTop as Number;
    private var _paddingBottom as Number;

    private var _currentAltitude as Number or Float;
    private var _currentSaturation as Number or Float;

    private var _width as Number;
    private var _height as Number;

    private var _topLeft as Point;
    private var _topRight as Point;
    private var _bottomLeft as Point;
    private var _bottomRight as Point;

    private var _canvasWidth as Number;
    private var _canvasHeight as Number; 

    private var _altitudeWindow as Number;

    private var _markerSize as Number;

    private var _showBestSaturation as Boolean;
    private var _showWorstSaturation as Boolean;

    private var _sensorHistory as SensorSnapshotCircularBufferIterator;

    public function initialize(options as {
        :width as Number,
        :height as Number,
        :paddingX as Number,
        :paddingTop as Number,
        :paddingBottom as Number,
        :currentAltitude as Number,
        :currentSaturation as Float,
        :altitudeWindow as Number,
        :markerSize as Number,
        :showBestSaturation as Boolean,
        :showWorstSaturation as Boolean,
        :sensorHistory as SensorSnapshotCircularBufferIterator
    }) {
        _width = options.get(:width);
        _height = options.get(:height);
        _paddingX = options.get(:paddingX);
        _paddingTop = options.get(:paddingTop);
        _paddingBottom = options.get(:paddingBottom);
        _currentAltitude = options.get(:currentAltitude);
        _currentSaturation = options.get(:currentSaturation);
        _altitudeWindow = options.get(:altitudeWindow);
        _markerSize = options.get(:markerSize);
        _showBestSaturation = options.get(:showBestSaturation);
        _showWorstSaturation = options.get(:showWorstSaturation);
        _sensorHistory = options.get(:sensorHistory);

        _topLeft = new Point(_paddingX, _paddingTop);
        _topRight = new Point(_width - _paddingX, _paddingTop);
        _bottomLeft = new Point(_paddingX, _height - _paddingBottom);
        _bottomRight = new Point(_width - _paddingX, _height - _paddingBottom);
        
        _canvasWidth = _topRight.x - _topLeft.x - 2;
        _canvasHeight = _bottomRight.y - _topRight.y; 
    }

    public function draw(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        drawBorders(dc);

        var xValues = [];
        var yValues = [];

        while (_sensorHistory.hasMore()) {
            var current = _sensorHistory.getNext();

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

        var minAltitude = MathUtils.max(_currentAltitude - _altitudeWindow, 0);
        var maxAltitude = _currentAltitude + _altitudeWindow;

        var maxSaturation = getMaxSaturation(minAltitude);
        var minSaturation = maxSaturation - 20;

        var altitudeScale = (maxAltitude - minAltitude) / _canvasWidth;
        var saturationScale = _canvasHeight / (maxSaturation - minSaturation);

        var currentPoint = getCurrentPoint(minAltitude, altitudeScale, saturationScale);

        var scrollY = 0;

        for (var canvasX = 0; canvasX <= _canvasWidth; canvasX++) {
            var altitude = minAltitude + canvasX * altitudeScale;
            var theoreticalSaturation = EquationUtils.getPolynomialTheoreticalSaturation(altitude);

            theoreticalSaturation = MathUtils.clamp(theoreticalSaturation, minSaturation, maxSaturation);

            var bestPossibleSaturation = theoreticalSaturation * 1.05;
            var worstPossibleSaturation = theoreticalSaturation * 0.95;

            if (currentPoint.y > _topLeft.y + _canvasHeight / 2) {
                scrollY = currentPoint.y - (_topLeft.y + _canvasHeight / 2);
            }

            var graphX = canvasX + _topLeft.x + 1;
            var bestGraphY = (_topLeft.y + saturationScale * (100 - bestPossibleSaturation) + 1) - scrollY;
            var graphY = (_topLeft.y + saturationScale * (100 - theoreticalSaturation) + 1) - scrollY;
            var worstGraphY = (_topLeft.y + saturationScale * (100 - worstPossibleSaturation) + 1) - scrollY;

            var bestNewPoint = new Point(graphX, bestGraphY);
            var newPoint = new Point(graphX, graphY);
            var worstNewPoint = new Point(graphX, worstGraphY);

            dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_BLACK);
            if (MathUtils.isInRectangle(_topLeft, _bottomRight, bestNewPoint) && _showBestSaturation) {
                dc.drawPoint(bestNewPoint.x, bestNewPoint.y);
            }
            if (MathUtils.isInRectangle(_topLeft, _bottomRight, worstNewPoint) && _showWorstSaturation) {
                dc.drawPoint(worstNewPoint.x, worstNewPoint.y);
            }

            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
            if (MathUtils.isInRectangle(_topLeft, _bottomRight, newPoint)) {
                dc.drawPoint(newPoint.x, newPoint.y);
            }
        }

        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_BLACK);
        for (var canvasX = 0; canvasX <= _canvasWidth; canvasX++) {
            var altitude = minAltitude + canvasX * altitudeScale;

            var upperSaturation = slopeUpper * altitude + interceptUpper;
            upperSaturation = MathUtils.clamp(upperSaturation, minSaturation, maxSaturation);

            var graphX = canvasX + _topLeft.x + 1;
            var upperGraphY = _topLeft.y + saturationScale * (100 - upperSaturation) + 1;
            upperGraphY -= scrollY;

            var upperPoint = new Point(graphX, upperGraphY);
            if (MathUtils.isInRectangle(_topLeft, _bottomRight, upperPoint)) {
                dc.drawPoint(upperPoint.x, upperPoint.y);
            }

            var lowerSaturation = slopeLower * altitude + interceptLower;
            lowerSaturation = MathUtils.clamp(lowerSaturation, minSaturation, maxSaturation);

            var lowerGraphY = _topLeft.y + saturationScale * (100 - lowerSaturation) + 1;
            lowerGraphY -= scrollY;

            var lowerPoint = new Point(graphX, lowerGraphY);
            if (MathUtils.isInRectangle(_topLeft, _bottomRight, lowerPoint)) {
                dc.drawPoint(lowerPoint.x, lowerPoint.y);
            }
        }

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        for (var canvasX = 0; canvasX <= _canvasWidth; canvasX++) {
            var altitude = minAltitude + canvasX * altitudeScale;
            var predictedSaturation = slope * altitude + intercept;

            predictedSaturation = MathUtils.clamp(predictedSaturation, minSaturation, maxSaturation);

            var graphX = canvasX + _topLeft.x + 1;
            var graphY = _topLeft.y + saturationScale * (100 - predictedSaturation) + 1;
            graphY -= scrollY; 

            var regressionPoint = new Point(graphX, graphY);

            if (MathUtils.isInRectangle(_topLeft, _bottomRight, regressionPoint)) {
                dc.drawPoint(regressionPoint.x, regressionPoint.y);
            }
        }

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        drawMarker(dc, currentPoint, scrollY);
        drawAltitude(dc, currentPoint, scrollY);
    }

    private function linearRegression(
        xValues as Array<Numeric>, 
        yValues as Array<Numeric>
    ) as {
        :slope as Numeric,
        :intercept as Numeric
    } {
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

    private function standardErrorSlope(
        xValues as Array<Numeric>, 
        yValues as Array<Numeric>, 
        slope as Numeric,
        intercept as Numeric
    ) as Numeric {
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

    private function confidenceInterval(
        xValues as Array<Numeric>, 
        yValues as Array<Numeric>, 
        slope as Numeric, 
        intercept as Numeric
    ) as {
        :slopeConfidenceInterval as {
            :lower as Numeric,
            :upper as Numeric
        },
        :interceptConfidenceInterval as {
            :lower as Numeric,
            :upper as Numeric
        }
    } {
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

    private function calculateTValue(df as Number) as Number {
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
        scrollY as Number
    ) as Void {
        var altitudeFormat = "($1$m)";
        var roundedAltitude = Math.round(_currentAltitude).toNumber();
        dc.drawText(
            currentPoint.x, 
            currentPoint.y + 4 + _markerSize - scrollY, 
            Graphics.FONT_XTINY,
            Lang.format(altitudeFormat, [roundedAltitude]), 
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    private function drawBorders(
        dc as Dc
    ) as Void {
        dc.drawLine(_topLeft.x, _topLeft.y, _topRight.x, _topRight.y);
        dc.drawLine(_bottomLeft.x, _bottomLeft.y, _bottomRight.x, _bottomRight.y);
        dc.drawLine(_topLeft.x, _topLeft.y, _bottomLeft.x, _bottomLeft.y); 
        dc.drawLine(_topRight.x, _topRight.y, _bottomRight.x, _bottomRight.y); 
    }

    private function drawMarker(
        dc as Dc, 
        point as Point,
        scrollY as Numeric
    ) as Void {
        dc.drawLine(point.x - _markerSize, point.y - _markerSize - scrollY, point.x + _markerSize, point.y + _markerSize - scrollY);
        dc.drawLine(point.x + _markerSize, point.y - _markerSize - scrollY, point.x - _markerSize, point.y + _markerSize - scrollY);
    }

    private function getMinSaturation(
        maxAltitude as Numeric
    ) as Numeric {
        return getSaturation(maxAltitude, 0.90);
    }

    private function getMaxSaturation(
        minAltitude as Numeric
    ) as Numeric {
        return getSaturation(minAltitude, 1.10);
    }

    private function getSaturation(
        altitude as Numeric,
        scale as Numeric
    ) as Numeric {
        var saturation = EquationUtils.getLinearTheoreticalSaturation(altitude) * scale;
        saturation = MathUtils.clamp(saturation, 0, 100);
        return saturation;
    }

    private function getCurrentPoint(
        minAltitude as Numeric,
        altitudeScale as Numeric,
        saturationScale as Numeric
    ) as Point {
        if (altitudeScale == 0) {
            altitudeScale = 1;
        }
        var scaledAltitude = (_currentAltitude - minAltitude) / altitudeScale; 
        var currentX = scaledAltitude + _topLeft.x + 1;
        var currentY = _topLeft.y + saturationScale * (100 - _currentSaturation) + 1;
        currentY = MathUtils.clamp(currentY, _topLeft.y, _bottomLeft.y);
        var currentPoint = new Point(currentX, currentY);
        return currentPoint;
    }

}
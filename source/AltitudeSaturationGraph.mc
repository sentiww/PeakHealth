import Toybox.Graphics;
import Toybox.Lang;
import MathUtils;
import EquationUtils;

class AltitudeSaturationGraph {

    var paddingX as Lang.Number;
    var paddingY as Lang.Number;

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

    function initialize(options as {
        :width as Lang.Number,
        :height as Lang.Number,
        :paddingX as Lang.Number,
        :paddingY as Lang.Number,
        :currentAltitude as Lang.Number,
        :currentSaturation as Lang.Float,
        :altitudeWindow as Lang.Number
    }) {
        width = options.get(:width);
        height = options.get(:height);
        paddingX = options.get(:paddingX);
        paddingY = options.get(:paddingY);
        currentAltitude = options.get(:currentAltitude);
        currentSaturation = options.get(:currentSaturation);
        altitudeWindow = options.get(:altitudeWindow);

        topLeft = new Point(paddingX, paddingY);
        topRight = new Point(width - paddingX, paddingY);
        bottomLeft = new Point(paddingX, height - paddingY);
        bottomRight = new Point(width - paddingX, height - paddingY);
        
        canvasWidth = topRight.x - topLeft.x - 2;
        canvasHeight = bottomRight.y - topRight.y; 
    }

    function draw(dc as Dc) {
        drawBorders(dc);

        var minAltitude = MathUtils.max(currentAltitude - altitudeWindow, 0);
        var maxAltitude = currentAltitude + altitudeWindow;

        var minSaturation = getMinSaturation(maxAltitude);
        var maxSaturation = getMaxSaturation(minAltitude);

        var altitudeScale = (maxAltitude - minAltitude) / canvasWidth;
        var saturationScale = canvasHeight / (maxSaturation - minSaturation);

        var currentPoint = getCurrentPoint(minAltitude, altitudeScale, saturationScale);

        for (var canvasX = 0; canvasX <= canvasWidth; canvasX++) {
            var altitude = minAltitude + canvasX * altitudeScale;
            var theoreticalSaturation = EquationUtils.getPolynomialTheoreticalSaturation(altitude);

            theoreticalSaturation = MathUtils.clamp(theoreticalSaturation, minSaturation, maxSaturation);

            var bestPossibleSaturation = theoreticalSaturation * 1.05;
            var possibleSaturation = theoreticalSaturation;
            var worstPossibleSaturation = theoreticalSaturation * 0.95;

            var scrollY = 0;
            if (currentPoint.y > topLeft.y + canvasHeight / 2) {
                scrollY = currentPoint.y - (topLeft.y + canvasHeight / 2);
            }

            var graphX = canvasX + topLeft.x + 1;
            var bestGraphY = (topLeft.y + saturationScale * (100 - bestPossibleSaturation) + 1) - scrollY;
            var graphY = (topLeft.y + saturationScale * (100 - possibleSaturation) + 1) - scrollY;
            var worstGraphY = (topLeft.y + saturationScale * (100 - worstPossibleSaturation) + 1) - scrollY;

            var bestNewPoint = new Point(graphX, bestGraphY);
            var newPoint = new Point(graphX, graphY);
            var worstNewPoint = new Point(graphX, worstGraphY);

            dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_BLACK);
            if (MathUtils.isInRectangle(topLeft, bottomRight, bestNewPoint)) {
                dc.drawPoint(bestNewPoint.x, bestNewPoint.y);
            }
            if (MathUtils.isInRectangle(topLeft, bottomRight, worstNewPoint)) {
                dc.drawPoint(worstNewPoint.x, worstNewPoint.y);
            }

            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
            if (MathUtils.isInRectangle(topLeft, bottomRight, newPoint)) {
                dc.drawPoint(worstNewPoint.x, worstNewPoint.y);
            }
        }

        var markerSize = 4;
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        drawMarker(dc, currentPoint, markerSize);
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
        size as Lang.Number or Lang.Float
    ) as Void {
        dc.drawLine(point.x - size, point.y - size, point.x + size, point.y + size);
        dc.drawLine(point.x + size, point.y - size, point.x - size, point.y + size);
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
        var scaledAltitude = (currentAltitude - minAltitude) / altitudeScale; 
        var currentX = scaledAltitude + topLeft.x + 1;
        var currentY = topLeft.y + saturationScale * (100 - currentSaturation) + 1;
        currentY = MathUtils.clamp(currentY, topLeft.y, bottomLeft.y);
        var currentPoint = new Point(currentX, currentY);
        return currentPoint;
    }
}
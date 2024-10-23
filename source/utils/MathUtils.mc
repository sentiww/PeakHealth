import Toybox.Lang;
import Toybox.System;

public module MathUtils {

    public function clamp(
        value as Lang.Number or Lang.Float,
        min as Lang.Number or Lang.Float,
        max as Lang.Number or Lang.Float
    ) as Lang.Number or Lang.Float {
        if (value < min) {
            return min;
        }

        if (value > max) {
            return max;
        }

        return value;
    }

    public function max(
        first as Lang.Number or Lang.Float, 
        second as Lang.Number or Lang.Float
    ) as Lang.Number or Lang.Float {
        if (first > second) {
            return first;
        }

        return second;
    }

    public function min(
        first as Lang.Number or Lang.Float, 
        second as Lang.Number or Lang.Float
    ) as Lang.Number or Lang.Float {
        if (first < second) {
            return first;
        }

        return second;
    }  

    public function isInRange(
        value as Lang.Number or Lang.Float,
        min as Lang.Number or Lang.Float,
        max as Lang.Number or Lang.Float
    ) as Lang.Boolean {
        return min < value and value < max;
    }

    public function isInRectangle(
        topLeft as Point,
        bottomRight as Point,
        point as Point
    ) as Lang.Boolean {
        return topLeft.x < point.x and 
               topLeft.y + 1 < point.y and
               bottomRight.x > point.x and
               bottomRight.y - 1 > point.y;
    } 
}
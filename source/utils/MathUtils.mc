import Toybox.Lang;
import Toybox.System;

public module MathUtils {

    public function clamp(
        value as Numeric,
        min as Numeric,
        max as Numeric
    ) as Numeric {
        if (value < min) {
            return min;
        }

        if (value > max) {
            return max;
        }

        return value;
    }

    public function max(
        first as Numeric, 
        second as Numeric
    ) as Numeric {
        if (first > second) {
            return first;
        }

        return second;
    }

    public function min(
        first as Numeric, 
        second as Numeric
    ) as Numeric {
        if (first < second) {
            return first;
        }

        return second;
    }  

    public function isInRange(
        value as Numeric,
        min as Numeric,
        max as Numeric
    ) as Boolean {
        return min < value and value < max;
    }

    public function isInRectangle(
        topLeft as Point,
        bottomRight as Point,
        point as Point
    ) as Boolean {
        return topLeft.x < point.x and 
               topLeft.y + 1 < point.y and
               bottomRight.x > point.x and
               bottomRight.y - 1 > point.y;
    } 

    public function sum(
        values as Array<Numeric>
    ) as Numeric {
        var accumulator = 0;

        for (var i = 0; i < values.size(); i++) {
            accumulator += values[i];
        }

        return accumulator;
    }
    
}
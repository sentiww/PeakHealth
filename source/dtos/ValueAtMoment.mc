import Toybox.Lang;
import Toybox.Time;

public class ValueAtMoment {

    public var moment as Moment;
    public var value as Numeric;

    function initialize(
        moment as Moment, 
        value as Numeric
    ) {
        self.moment = moment;
        self.value = value;
    }

}
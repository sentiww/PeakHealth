import Toybox.Lang;
import Toybox.Time;

public class SensorSnapshot {

    public var moment as Moment;
    public var altitude as Numeric;
    public var saturation as Numeric;

    public function initialize(
        moment as Moment, 
        altitude as Numeric, 
        saturation as Numeric
    ) {
        self.moment = moment;
        self.altitude = altitude;
        self.saturation = saturation;
    }

}
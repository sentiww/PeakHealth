class SensorSnapshot {
    public var moment;
    public var altitude;
    public var saturation;

    function initialize(moment, altitude, saturation) {
        self.moment = moment;
        self.altitude = altitude;
        self.saturation = saturation;
    }
}
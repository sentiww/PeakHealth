import Toybox.Lang;
import Toybox.Sensor;
import Toybox.System;
import Toybox.Time;
import Toybox.Application.Storage;

class SensorHandler {

    private static var _instance as SensorHandler;

    private var _currentSaturation as ValueAtMoment;
    private var _currentAltitude as ValueAtMoment;

    private var _sensorHistory as CircularBuffer;

    private function initialize() {
        var now = Time.now();

        _currentSaturation = new ValueAtMoment(now, 100);
        _currentAltitude = new ValueAtMoment(now, 0);
        _sensorHistory = new CircularBuffer(1000);            

        Sensor.setEnabledSensors([Sensor.SENSOR_ONBOARD_PULSE_OXIMETRY]);
        Sensor.enableSensorEvents(method(:onSensorEvents));
    }

    public static function getInstance() as SensorHandler {
        if (_instance == null) {
            _instance = new SensorHandler();
        }

        return _instance;
    }

    public function getSensorHistory() as CircularBuffer {
        return _sensorHistory;
    }

    private var debugAltitude = 0;

    function onSensorEvents(sensorInfo as Info) {
        if (sensorInfo == null) {
            return;
        }

        var now = Time.now();

        var oxygenSaturation = sensorInfo.oxygenSaturation; 
        var altitude = sensorInfo.altitude;

        debugAltitude += Math.rand() % 100;

        altitude = debugAltitude;
        oxygenSaturation = EquationUtils.getLinearTheoreticalSaturation(altitude) + Math.rand() % 5 - Math.rand() % 5;

        if (shouldSetCurrent(oxygenSaturation, altitude)) {
            _currentSaturation = new ValueAtMoment(now, oxygenSaturation);
            _currentAltitude = new ValueAtMoment(now, altitude);
        }

        if (shouldAddSensorSnapshot(oxygenSaturation, altitude)) {
            var sensorSnapshot = new SensorSnapshot(now, altitude, oxygenSaturation);
            _sensorHistory.add(sensorSnapshot);
        }
    }

    private function shouldSetCurrent(saturation, altitude) as Lang.Boolean {
        if (saturation == null or altitude == null) {
            return false;
        }

        return true;
    }

    private function shouldAddSensorSnapshot(saturation, altitude) as Lang.Boolean {
        if (saturation == null or altitude == null) {
            return false;
        }

        var latestSnapshot = _sensorHistory.getLatest() as SensorSnapshot;

        if (latestSnapshot == null) {
            return true;
        }

        var latestSaturation = Math.round(latestSnapshot.saturation).toNumber();
        var currentSaturation = Math.round(saturation).toNumber();
        var isSameSaturation = latestSaturation == currentSaturation;
        var minAltitude = latestSnapshot.altitude - 50;
        var maxAltitude = latestSnapshot.altitude + 50;
        var isAltitudeInBounds = minAltitude < altitude and altitude < maxAltitude;
        if (isSameSaturation and isAltitudeInBounds) {
            return false;
        }

        return true;
    }

    public function getCurrentSaturation() {
        return _currentSaturation;
    }

    public function getCurrentAltitude() {
        return _currentAltitude;
    }
}
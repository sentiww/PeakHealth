import Toybox.Lang;
import Toybox.Sensor;
import Toybox.System;
import Toybox.Time;
import Toybox.Application.Storage;

class SensorHandler {

    private static var _instance as SensorHandler;

    private var _currentSaturation as ValueAtMoment;
    private var _currentAltitude as ValueAtMoment;

    private var _sensorHistory as SensorSnapshotCircularBuffer;

    private function initialize() {
        var now = Time.now();

        _currentSaturation = new ValueAtMoment(now, 100);
        _currentAltitude = new ValueAtMoment(now, 0);
        _sensorHistory = new SensorSnapshotCircularBuffer(500);            

        Sensor.setEnabledSensors([Sensor.SENSOR_ONBOARD_PULSE_OXIMETRY]);
        Sensor.enableSensorEvents(method(:onSensorEvents));
    }

    public static function getInstance() as SensorHandler {
        if (_instance == null) {
            _instance = new SensorHandler();
        }

        return _instance;
    }

    public function getSensorHistoryIterator() as SensorSnapshotCircularBufferIterator {
        return new SensorSnapshotCircularBufferIterator(_sensorHistory);
    }

    private var debugAltitude = 0;

    public function onSensorEvents(sensorInfo as Info) as Void {
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

    private function shouldSetCurrent(
        saturation as Numeric or Null, 
        altitude as Numeric or Null
    ) as Boolean {
        if (saturation == null or altitude == null) {
            return false;
        }

        return true;
    }

    private function shouldAddSensorSnapshot(
        saturation as Numeric or Null, 
        altitude as Numeric or Null
    ) as Boolean {
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

    public function getCurrentSaturation() as ValueAtMoment {
        return _currentSaturation;
    }

    public function getCurrentAltitude() as ValueAtMoment {
        return _currentAltitude;
    }
}
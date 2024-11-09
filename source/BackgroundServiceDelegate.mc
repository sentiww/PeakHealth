import Toybox.Background;
import Toybox.System;

(:background)
class BackgroundServiceDelegate extends System.ServiceDelegate {

    function initialize() {
        ServiceDelegate.initialize();
        System.println("PeakHealthServiceDelegate initialized");
    }

    function onTemporalEvent() {
        var sensorHandler = SensorHandler.getInstance();

        var altitude = sensorHandler.getCurrentAltitude();
        var saturation = sensorHandler.getCurrentSaturation();

        if (saturation.value <= EquationUtils.getLinearTheoreticalSaturation(altitude) * 0.95) {
            Background.requestApplicationWake("Test message");
            Background.exit(null);
        }
    }

}
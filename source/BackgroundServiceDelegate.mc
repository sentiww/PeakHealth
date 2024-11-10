import Toybox.Background;
import Toybox.System;

(:background)
public class BackgroundServiceDelegate extends System.ServiceDelegate {

    public function initialize() {
        ServiceDelegate.initialize();
        System.println("PeakHealthServiceDelegate initialized");
    }

    public function onTemporalEvent() as Void {
        var sensorHandler = SensorHandler.getInstance();

        var altitude = sensorHandler.getCurrentAltitude();
        var saturation = sensorHandler.getCurrentSaturation();

        if (saturation.value <= EquationUtils.getLinearTheoreticalSaturation(altitude) * 0.95) {
            Background.requestApplicationWake("Test message");
            Background.exit(null);
        }
    }

}
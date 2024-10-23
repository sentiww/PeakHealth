import Toybox.Background;
import Toybox.System;

(:background)
class BackgroundServiceDelegate extends System.ServiceDelegate {

    function initialize() {
        ServiceDelegate.initialize();
        System.println("PeakHealthServiceDelegate initialized");
    }

    function onTemporalEvent() {
        System.println("IN TEMPORAL");

        // TODO: Add background alert when actual saturation is below threshold
        if (false) {
            Background.requestApplicationWake("Test message");
            Background.exit(null);
        }
    }

}
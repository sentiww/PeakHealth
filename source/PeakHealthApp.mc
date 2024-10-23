import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Sensor;

(:background)
class PeakHealthApp extends Application.AppBase {

    const fiveMinutes = new Time.Duration(5 * 60);

    function initialize() {
        AppBase.initialize();

        if (Toybox.System has :ServiceDelegate){
            Background.registerForTemporalEvent(fiveMinutes);
            System.println("Registered background service");
        }
        else {
            System.println("Device doesn't support background services");
        }
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new PeakHealthView(), new PeakHealthDelegate() ];
    }

    
    function getServiceDelegate() {
        return [new BackgroundServiceDelegate()];
    }
}

function getApp() as PeakHealthApp {
    return Application.getApp() as PeakHealthApp;
}
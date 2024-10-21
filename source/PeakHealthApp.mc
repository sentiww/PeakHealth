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

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new PeakHealthView(), new PeakHealthDelegate() ];
    }

    
    function getServiceDelegate() {
        return [new PeakHealthServiceDelegate()];
    }
}

function getApp() as PeakHealthApp {
    return Application.getApp() as PeakHealthApp;
}
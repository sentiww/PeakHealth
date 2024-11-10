import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Sensor;

(:background)
public class PeakHealthApp extends Application.AppBase {

    private var sensorHandler as SensorHandler;

    private const fiveMinutes = new Time.Duration(5 * 60);

    public function initialize() {
        AppBase.initialize();

        if (Toybox.System has :ServiceDelegate){
            Background.registerForTemporalEvent(fiveMinutes);
            System.println("Registered background service");
        }
        else {
            System.println("Device doesn't support background services");
        }

        sensorHandler = SensorHandler.getInstance();
    }

    public function onStart(state as Dictionary?) as Void {
    
    }

    public function onStop(state as Dictionary?) as Void {
    
    }

    public function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new PeakHealthView(), new PeakHealthDelegate() ];
    }
    
    public function getServiceDelegate() {
        return [new BackgroundServiceDelegate()];
    }
}

public function getApp() as PeakHealthApp {
    return Application.getApp() as PeakHealthApp;
}
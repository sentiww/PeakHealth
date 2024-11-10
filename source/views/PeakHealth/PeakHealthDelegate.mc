import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Storage;

public class PeakHealthDelegate extends WatchUi.BehaviorDelegate {

    public function initialize() {
        BehaviorDelegate.initialize();
    }

    public function onMenu() as Boolean {
        WatchUi.pushView(new MenuView(), new MenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}
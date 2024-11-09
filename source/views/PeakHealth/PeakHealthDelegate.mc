import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Storage;

class PeakHealthDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new MenuView(), new MenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}
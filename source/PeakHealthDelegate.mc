import Toybox.Lang;
import Toybox.WatchUi;

class PeakHealthDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        var menu = new WatchUi.Menu2({
            :title=>"Menu!"
        });

        menu.addItem(
            new MenuItem(
                "Altitude window",
                "Visible altitude window",
                "altitude_window",
                {}
            )
        );

        WatchUi.pushView(menu, new PeakHealthMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}
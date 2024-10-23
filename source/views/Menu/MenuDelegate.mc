import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;

class MenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) {
        var itemId = item.getId();

        if (itemId.equals("altitude_window")) {
            WatchUi.pushView(new AltitudePicker(), new AltitudePickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }
    }

}
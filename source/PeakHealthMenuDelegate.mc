import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class PeakHealthMenuDelegate extends WatchUi.Menu2InputDelegate {

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
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;

class DebugDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) {
        var itemId = item.getId();

    }

}
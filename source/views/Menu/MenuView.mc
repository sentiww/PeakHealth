import Toybox.WatchUi;
import Toybox.Lang;

class MenuView extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({
            :title=>"Settings"
        });

        var altitueWindow = new MenuItem(
            "Altitude window",
            "Visible altitude window",
            "altitude_window",
            {}
        );

        var bestSaturation = new MenuItem(
            "Show best line",
            "2.5 percentiles",
            "best_saturation",
            {}
        );

        var worstSaturation = new MenuItem(
            "Show worst line",
            "97.5 percentiles",
            "worst_saturation",
            {}
        );

        var debug = new MenuItem(
            "Debug",
            "Show variables",
            "debug",
            {}
        );

        var menuItems = [
            altitueWindow,
            bestSaturation,
            worstSaturation,
            debug
        ] as Array<MenuItem>;

        for (var index = 0; index < menuItems.size(); index++) {
            var menuItem = menuItems[index];
            self.addItem(menuItem);
        }
    }

}
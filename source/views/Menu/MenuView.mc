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

        var menuItems = [
            altitueWindow
        ] as Array<MenuItem>;

        for (var index = 0; index < menuItems.size(); index++) {
            var menuItem = menuItems[index];
            self.addItem(menuItem);
        }
    }
    
}
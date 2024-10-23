using Toybox.WatchUi;

class MenuView extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({
            :title=>"Settings"
        });

        self.addItem(
            new MenuItem(
                "Altitude window",
                "Visible altitude window",
                "altitude_window",
                {}
            )
        );
    }
}
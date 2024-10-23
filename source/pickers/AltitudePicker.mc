import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class AltitudePicker extends WatchUi.Picker {

    hidden var _startAltitude = 100;
    hidden var _stopAltitude = 1000;
    hidden var _altitudeStep = 100;

    public function initialize() {
        var title = new WatchUi.Text({
            :text=>$.Rez.Strings.altitudePickerName, 
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, 
            :color=>Graphics.COLOR_WHITE
        });

        Picker.initialize({
            :title=>title, 
            :pattern=>[
                new $.NumberFactory(
                    _startAltitude, 
                    _stopAltitude, 
                    _altitudeStep, 
                    { :font=>Graphics.FONT_TINY })
            ]});
    }

    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class AltitudePickerDelegate extends WatchUi.PickerDelegate {

    public function initialize() {
        PickerDelegate.initialize();
    }

    public function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    public function onAccept(values as Array) as Boolean {
        var altitudeWindow = values[0];
        Storage.setValue("graph_altitude_window", altitudeWindow);

        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}
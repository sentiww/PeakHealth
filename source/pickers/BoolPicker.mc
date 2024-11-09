import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class BoolPicker extends WatchUi.Picker {

    hidden var _startAltitude = 100;
    hidden var _stopAltitude = 1000;
    hidden var _altitudeStep = 100;

    public function initialize(titleText as String) {
        var title = new WatchUi.Text({
            :text=>titleText, 
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, 
            :color=>Graphics.COLOR_WHITE
        });

        Picker.initialize({
            :title=>title, 
            :pattern=>[
                new BoolFactory({ 
                    :font=>Graphics.FONT_TINY,
                    :trueString=>"Yes",
                    :falseString=>"No" 
                })
            ]});
    }

    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
    
}

class BoolPickerDelegate extends WatchUi.PickerDelegate {

    hidden var _key as String;

    public function initialize(
        key as String
    ) {
        PickerDelegate.initialize();

        _key = key;
    }

    public function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    public function onAccept(values as Array<String>) as Boolean {
        System.println(values);

        var value = values[0];

        Storage.setValue(_key, value.equals("Yes"));

        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}
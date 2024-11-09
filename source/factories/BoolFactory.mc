import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class BoolFactory extends WatchUi.PickerFactory {

    hidden var _font as FontDefinition;
    hidden var _values as Array<String>;
    hidden var _trueString as String;
    hidden var _falseString as String;

    public function initialize(
        options as {
            :font as FontDefinition,
            :trueString as String,
            :falseString as String
    }) {
        PickerFactory.initialize();

        _trueString = options.get(:trueString);
        _falseString = options.get(:falseString);

        _values = [
            _trueString,
            _falseString
        ];

        var font = options.get(:font);
        if (font != null) {
            _font = font;
        } else {
            _font = Graphics.FONT_NUMBER_HOT;
        }
    }

    public function getIndex(value as String) as Number {
        return _values.indexOf(value);
    }

    public function getDrawable(index as Number, selected as Boolean) as Drawable? {
        var value = getValue(index);
        
        return new WatchUi.Text({
            :text=>value, 
            :color=>Graphics.COLOR_WHITE, 
            :font=>_font,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER, 
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });
    }

    public function getValue(index as Number) as String {
        return _values[index];
    }

    public function getSize() as Number {
        return _values.size();
    }

}
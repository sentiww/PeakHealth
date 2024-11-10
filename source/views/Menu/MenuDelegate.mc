import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;

public class MenuDelegate extends WatchUi.Menu2InputDelegate {

    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item as WatchUi.MenuItem) as Void {
        var itemId = item.getId();

        if (itemId.equals("altitude_window")) {
            WatchUi.pushView(new AltitudePicker(), new AltitudePickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }
        else if (itemId.equals("best_saturation")) {
            WatchUi.pushView(new BoolPicker("Show best"), new BoolPickerDelegate("show_best_saturation"), WatchUi.SLIDE_IMMEDIATE);
        }
        else if (itemId.equals("worst_saturation")) {
            WatchUi.pushView(new BoolPicker("Show worst"), new BoolPickerDelegate("show_worst_saturation"), WatchUi.SLIDE_IMMEDIATE);
        }
        else if (itemId.equals("tutorial")) {
            var tutorialView = new TutorialView();
            WatchUi.pushView(tutorialView, new TutorialDelegate(tutorialView), WatchUi.SLIDE_IMMEDIATE);
        }
        else if (itemId.equals("debug")) {
            WatchUi.pushView(new DebugView(), new DebugDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }
    }

}
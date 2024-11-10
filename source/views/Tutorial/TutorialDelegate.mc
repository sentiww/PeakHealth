import Toybox.Lang;
import Toybox.WatchUi;

public class TutorialDelegate extends WatchUi.BehaviorDelegate {

    private var _state;
    private var _tutorialView as TutorialView;

    public function initialize(tutorialView as TutorialView) {
        BehaviorDelegate.initialize();

        _state = TutorialState.WELCOME;
        _tutorialView = tutorialView;
    }

    public function onMenu() as Boolean {
        WatchUi.pushView(new MenuView(), new MenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    public function onSelect() as Boolean {
        System.println(_state);

        if (_state == TutorialState.WELCOME) {
            _state = TutorialState.ACTUAL_SATURATION;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.ACTUAL_SATURATION) {
            _state = TutorialState.THEORETICAL_SATURATION;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.THEORETICAL_SATURATION) {
            _state = TutorialState.GRAPH_1;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_1) {
            _state = TutorialState.GRAPH_2;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_2) {
            _state = TutorialState.GRAPH_3;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_3) {
            _state = TutorialState.GRAPH_4;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_4) {
            _state = TutorialState.GRAPH_5;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_5) {
            _state = TutorialState.GRAPH_6;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_6) {
            _state = TutorialState.GRAPH_7;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_7) {
            _state = TutorialState.GRAPH_8;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_8) {
            _state = TutorialState.GRAPH_9;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_9) {
            _state = TutorialState.GRAPH_10;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_10) {
            _state = TutorialState.GRAPH_11;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_11) {
            _state = TutorialState.GRAPH_12;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_12) {
            _state = TutorialState.BACKGROUND_SERVICE_1;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.BACKGROUND_SERVICE_1) {
            _state = TutorialState.BACKGROUND_SERVICE_2;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.BACKGROUND_SERVICE_2) {
            _state = TutorialState.OPTIONS;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.OPTIONS) {
            _state = TutorialState.WARNING_1;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.WARNING_1) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
        else {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
        
        return true;
    }

    public function onBack() as Boolean {
        if (_state == TutorialState.WELCOME) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
        else if (_state == TutorialState.ACTUAL_SATURATION) {
            _state = TutorialState.WELCOME;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.THEORETICAL_SATURATION) {
            _state = TutorialState.ACTUAL_SATURATION;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_1) {
            _state = TutorialState.THEORETICAL_SATURATION;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_2) {
            _state = TutorialState.GRAPH_1;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_3) {
            _state = TutorialState.GRAPH_2;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_4) {
            _state = TutorialState.GRAPH_3;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_5) {
            _state = TutorialState.GRAPH_4;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_6) {
            _state = TutorialState.GRAPH_5;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_7) {
            _state = TutorialState.GRAPH_6;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_8) {
            _state = TutorialState.GRAPH_7;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_9) {
            _state = TutorialState.GRAPH_8;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_10) {
            _state = TutorialState.GRAPH_9;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_11) {
            _state = TutorialState.GRAPH_10;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.GRAPH_12) {
            _state = TutorialState.GRAPH_11;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.BACKGROUND_SERVICE_1) {
            _state = TutorialState.GRAPH_12;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.BACKGROUND_SERVICE_2) {
            _state = TutorialState.BACKGROUND_SERVICE_1;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.OPTIONS) {
            _state = TutorialState.BACKGROUND_SERVICE_2;
            _tutorialView.setState(_state);
        }
        else if (_state == TutorialState.WARNING_1) {
            _state = TutorialState.OPTIONS;
            _tutorialView.setState(_state);
        }
        else {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }

        return true;
    }

}
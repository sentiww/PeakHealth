import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.UserProfile;
import Toybox.Background;
import Toybox.Time;
import Toybox.Math;
import Toybox.Lang;
import Toybox.Application.Storage;
import EquationUtils;
import MathUtils;
import Toybox.Timer;

class TutorialView extends WatchUi.View {

    private var _state;

    private var _topText;
    private var _middleText;
    private var _bottomText;
    private var _graph;

    private var _riskSensorHistory;
    private var _sampleSensorHistory;
    private var _sampleGraph;
    private var _riskGraph;

    private var _width;
    private var _height;

    function initialize() {
        View.initialize();

        _width = null;
        _height = null;

        setState(TutorialState.WELCOME);
    }

    function onLayout(dc as Dc) as Void {
    }

    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        
        if (_width == null) {
            _width = dc.getWidth();
        }
        if (_height == null) {
            _height = dc.getHeight();
        }
        if (_sampleGraph == null) {
            var sensorHistoryBuffer = new CircularBuffer(10);
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1000, 100));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1100, 100));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1200, 100));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1300, 99));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1400, 99));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1500, 99));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1600, 99));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1700, 98));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1800, 98));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1900, 97));
            _sampleSensorHistory = new CircularBufferIterator(sensorHistoryBuffer);
            _sampleGraph = new AltitudeSaturationGraph({
                :width=>_width,
                :height=>_height,
                :paddingX=>50,
                :paddingTop=>25,
                :paddingBottom=>125,
                :currentAltitude=>2000,
                :currentSaturation=>97,
                :altitudeWindow=>200,
                :markerSize=>4,
                :showBestSaturation=>true,
                :showWorstSaturation=>true,
                :sensorHistory=>_sampleSensorHistory
            });
        }
        if (_riskGraph == null) {
            var sensorHistoryBuffer = new CircularBuffer(10);
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1000, 100));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1100, 100));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1200, 99));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1300, 99));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1400, 95));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1500, 95));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1600, 94));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1700, 93));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1800, 91));
            sensorHistoryBuffer.add(new SensorSnapshot(null, 1900, 91));
            _riskSensorHistory = new CircularBufferIterator(sensorHistoryBuffer);
            _riskGraph = new AltitudeSaturationGraph({
                :width=>_width,
                :height=>_height,
                :paddingX=>50,
                :paddingTop=>25,
                :paddingBottom=>125,
                :currentAltitude=>2000,
                :currentSaturation=>91,
                :altitudeWindow=>200,
                :markerSize=>4,
                :showBestSaturation=>true,
                :showWorstSaturation=>true,
                :sensorHistory=>_riskSensorHistory
            });
        }

        if (_topText != null) {
            _topText.draw(dc);
        }
        if (_middleText != null) {
            _middleText.draw(dc);
        }
        if (_bottomText != null) {
            _bottomText.draw(dc);
        }
        if (_graph != null) {
            _graph.draw(dc);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function setState(state) as Void {
        _state = state;
        
        if (_state == TutorialState.WELCOME) {
            _topText = new WatchUi.Text({
                :text=>"Welcome!",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_SMALL,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_TOP
            });

            _middleText = new WatchUi.TextArea({
                :text=>"This tutorial will help you quickly learn how to use PeakHealth.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_CENTER,
                :width=>160,
                :height=>160
            });

            _bottomText = null;

            _graph = null;
        }
        else if (_state == TutorialState.ACTUAL_SATURATION) {
            _topText = new WatchUi.Text({
                :text=>"100",
                :color=>Graphics.COLOR_RED,
                :font=>Graphics.FONT_MEDIUM,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_TOP
            });

            _middleText = new WatchUi.TextArea({
                :text=>"The red value at the top of the screen shows the latest measured arterial blood oxygen saturation.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_CENTER,
                :width=>160,
                :height=>160
            });

            _bottomText = null;

            _graph = null;
        }
        else if (_state == TutorialState.THEORETICAL_SATURATION) {
            _topText = null;

            _middleText = new WatchUi.TextArea({
                :text=>"The blue value at the bottom of the screen shows the theoretical arterial blood oxygen saturation for the current altitude.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_CENTER,
                :width=>160,
                :height=>160
            });
            
            _bottomText = new WatchUi.Text({
                :text=>"100",
                :color=>Graphics.COLOR_BLUE,
                :font=>Graphics.FONT_MEDIUM,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM
            });

            _graph = null;
        }
        else if (_state == TutorialState.GRAPH_1) {
            _topText = null;

            _middleText = null;

            _bottomText = new WatchUi.TextArea({
                :text=>"The altitude-SpO2 graph is one of the main functionalities of PeakHealth.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>120
            });

            _sampleSensorHistory.reset();
            _graph = _sampleGraph;
        }
        else if (_state == TutorialState.GRAPH_2) {
            _topText = null;

            _middleText = null;

            _bottomText = new WatchUi.TextArea({
                :text=>"It allows you to quickly check your saturation with the theoretical saturation.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>120
            });

            _sampleSensorHistory.reset();
            _graph = _sampleGraph;
        }
        else if (_state == TutorialState.GRAPH_3) {
            _topText = null;

            _middleText = null;

            _bottomText = new WatchUi.TextArea({
                :text=>"The red X shows your current place in the altitude-SpO2 graph.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>120
            });

            _sampleSensorHistory.reset();
            _graph = _sampleGraph;
        }
        else if (_state == TutorialState.GRAPH_4) {
            _topText = null;

            _middleText = null;

            _bottomText = new WatchUi.TextArea({
                :text=>"The red text below shows your current altitude.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>120
            });

            _sampleSensorHistory.reset();
            _graph = _sampleGraph;
        }
        else if (_state == TutorialState.GRAPH_5) {
            _topText = null;

            _middleText = null;

            _bottomText = new WatchUi.TextArea({
                :text=>"The bright red line is the linear regression of your altitude-SpO2.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>120
            });

            _sampleSensorHistory.reset();
            _graph = _sampleGraph;
        }
        else if (_state == TutorialState.GRAPH_6) {
            _topText = null;

            _middleText = null;

            _bottomText = new WatchUi.TextArea({
                :text=>"The dark red lines above and below this line are...",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>120
            });

            _sampleSensorHistory.reset();
            _graph = _sampleGraph;
        }
        else if (_state == TutorialState.GRAPH_7) {
            _topText = null;

            _middleText = null;

            _bottomText = new WatchUi.TextArea({
                :text=>"...the 97.5% confidence intervals.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>120
            });

            _sampleSensorHistory.reset();
            _graph = _sampleGraph;
        }
        else if (_state == TutorialState.GRAPH_8) {
            _topText = null;

            _middleText = null;

            _bottomText = new WatchUi.TextArea({
                :text=>"The bright blue line is the theoretical altitude-SpO2 value.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>120
            });

            _sampleSensorHistory.reset();
            _graph = _sampleGraph;            
        }
        else if (_state == TutorialState.GRAPH_9) {
            _topText = null;

            _middleText = null;

            _bottomText = new WatchUi.TextArea({
                :text=>"The dark blue lines above and below this line are...",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>120
            });

            _sampleSensorHistory.reset();
            _graph = _sampleGraph;
        }
        else if (_state == TutorialState.GRAPH_10) {
            _topText = null;

            _middleText = null;

            _bottomText = new WatchUi.TextArea({
                :text=>"...the 97.5% percentile lines.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>120
            });

            _sampleSensorHistory.reset();
            _graph = _sampleGraph;
        }
        else if (_state == TutorialState.GRAPH_11) {
            _topText = null;

            _middleText = null;

            _bottomText = new WatchUi.TextArea({
                :text=>"This graph shows a low risk of experiencing altitude sickness.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>120
            });

            _sampleSensorHistory.reset();
            _graph = _sampleGraph;
        }
        else if (_state == TutorialState.GRAPH_12) {
            _topText = null;

            _middleText = null;

            _bottomText = new WatchUi.TextArea({
                :text=>"This graph shows a high risk of experiencing altitude sickness.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>120
            });

            _riskSensorHistory.reset();
            _graph = _riskGraph;
        }
        else if (_state == TutorialState.BACKGROUND_SERVICE_1) {
            _topText = null;

            _middleText = new WatchUi.TextArea({
                :text=>"The application also works in the background.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>160
            });

            _bottomText = null;

            _graph = null;
        }
        else if (_state == TutorialState.BACKGROUND_SERVICE_2) {
            _topText = null;

            _middleText = new WatchUi.TextArea({
                :text=>"You will be notified if your altitude-SpO2 is dangerously low.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>160
            });

            _bottomText = null;

            _graph = null;
        }
        else if (_state == TutorialState.OPTIONS) {
            _topText = null;

            _middleText = new WatchUi.TextArea({
                :text=>"The application is highly custimizeable, check options for more.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>160
            });

            _bottomText = null;

            _graph = null;
        }
        else if (_state == TutorialState.WARNING_1) {
            _topText = null;

            _middleText = new WatchUi.TextArea({
                :text=>"Remember to only use this application as a reference.",
                :color=>Graphics.COLOR_WHITE,
                :font=>Graphics.FONT_XTINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                :width=>160,
                :height=>160
            });

            _bottomText = null;

            _graph = null;
        }
        else {
            _topText = null;

            _middleText = null;

            _bottomText = null;

            _graph = null;
        }

        WatchUi.requestUpdate();
    }
}

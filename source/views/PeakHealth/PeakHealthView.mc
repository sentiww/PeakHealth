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

public class PeakHealthView extends WatchUi.View {

    private var _oxygenSaturationText;
    private var _aosText;
    private var _graph;
    private var _currentAltitude;
    private var _currentSaturation;
    private var _window as Number;
    private var _showBestSaturation as Boolean;
    private var _showWorstSaturation as Boolean;
    private var _timer as Timer;

    public function initialize() {
        View.initialize();

        _currentAltitude = 0;
        _currentSaturation = EquationUtils.getLinearTheoreticalSaturation(_currentAltitude);

        _showBestSaturation = Storage.getValue("show_best_saturation");
        if (_showBestSaturation == null) {
            _showBestSaturation = true;
        }

        _showWorstSaturation = Storage.getValue("show_worst_saturation");
        if (_showWorstSaturation == null) {
            _showWorstSaturation = true;
        }

        _window = Storage.getValue("graph_altitude_window");
        if (_window == null) {
            _window = 1000;
        }

        _timer = new Timer.Timer();
    }

    public function onLayout(dc as Dc) as Void {
    
    }

    public function onShow() as Void {
        _timer.start(method(:timerCallback), 5000, true);

        var shownTutorial = Storage.getValue("shown_tutorial");
        if (shownTutorial == null or !shownTutorial) {
            var tutorialView = new TutorialView();
            WatchUi.pushView(tutorialView, new TutorialDelegate(tutorialView), WatchUi.SLIDE_IMMEDIATE);
            Storage.setValue("shown_tutorial", true);
        }

        _oxygenSaturationText = new WatchUi.Text({
            :text=>"000",
            :color=>Graphics.COLOR_RED,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_TOP
        });

        _aosText = new WatchUi.Text({
            :text=>"000",
            :color=>Graphics.COLOR_BLUE,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM
        });

        _showBestSaturation = Storage.getValue("show_best_saturation");
        if (_showBestSaturation == null) {
            _showBestSaturation = true;
        }

        _showWorstSaturation = Storage.getValue("show_worst_saturation");
        if (_showWorstSaturation == null) {
            _showWorstSaturation = true;
        }

        _window = Storage.getValue("graph_altitude_window");
        if (_window == null) {
            _window = 1000;
        }
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        _oxygenSaturationText.draw(dc);
        _aosText.draw(dc);

        dc.setAntiAlias(true);

        var sensorHandler = SensorHandler.getInstance();
        _graph = new AltitudeSaturationGraph({
            :width=>dc.getWidth(),
            :height=>dc.getHeight(),
            :paddingX=>25,
            :paddingTop=>50,
            :paddingBottom=>50,
            :currentAltitude=>_currentAltitude,
            :currentSaturation=>_currentSaturation,
            :altitudeWindow=>_window,
            :markerSize=>4,
            :showBestSaturation=>_showBestSaturation,
            :showWorstSaturation=>_showWorstSaturation,
            :sensorHistory=>sensorHandler.getSensorHistoryIterator()
        });
        _graph.draw(dc);
    }

    public function onHide() as Void {
        _timer.stop();
    }

    public function timerCallback() as Void {
        var sensorHandler = SensorHandler.getInstance();

        _currentSaturation = sensorHandler.getCurrentSaturation().value;
        _currentAltitude = sensorHandler.getCurrentAltitude().value;

        System.println("Got sensor update");

        var aos = EquationUtils.getLinearTheoreticalSaturation(_currentAltitude);
        aos = MathUtils.clamp(aos, 0, 100);
        
        _oxygenSaturationText.setText(_currentSaturation.format("%02d"));
        _aosText.setText(aos.format("%02d"));

        WatchUi.requestUpdate();
    }
}

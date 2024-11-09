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

class PeakHealthView extends WatchUi.View {

    hidden var oxygenSaturationText;
    hidden var aosText;
    hidden var graph;
    hidden var currentAltitude;
    hidden var currentSaturation;
    hidden var window as Lang.Number;
    hidden var showBestSaturation as Lang.Boolean;
    hidden var showWorstSaturation as Lang.Boolean;
    hidden var timer as Timer;

    function initialize() {
        View.initialize();

        currentAltitude = 0;
        currentSaturation = EquationUtils.getLinearTheoreticalSaturation(currentAltitude);

        showBestSaturation = Storage.getValue("show_best_saturation");
        if (showBestSaturation == null) {
            showBestSaturation = true;
        }

        showWorstSaturation = Storage.getValue("show_worst_saturation");
        if (showWorstSaturation == null) {
            showWorstSaturation = true;
        }

        window = Storage.getValue("graph_altitude_window");
        if (window == null) {
            window = 1000;
        }

        timer = new Timer.Timer();
        timer.start(method(:timerCallback), 5000, true);
    }

    function onLayout(dc as Dc) as Void {
    }

    function onShow() as Void {
        oxygenSaturationText = new WatchUi.Text({
            :text=>"000",
            :color=>Graphics.COLOR_RED,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_TOP
        });

        aosText = new WatchUi.Text({
            :text=>"000",
            :color=>Graphics.COLOR_BLUE,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM
        });

        showBestSaturation = Storage.getValue("show_best_saturation");
        if (showBestSaturation == null) {
            showBestSaturation = true;
        }

        showWorstSaturation = Storage.getValue("show_worst_saturation");
        if (showWorstSaturation == null) {
            showWorstSaturation = true;
        }

        window = Storage.getValue("graph_altitude_window");
        if (window == null) {
            window = 1000;
        }
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        oxygenSaturationText.draw(dc);
        aosText.draw(dc);

        dc.setAntiAlias(true);

        graph = new AltitudeSaturationGraph({
            :width=>dc.getWidth(),
            :height=>dc.getHeight(),
            :paddingX=>25,
            :paddingY=>50,
            //:currentAltitude=>1000,
            //:currentSaturation=>95,
            :currentAltitude=>currentAltitude,
            :currentSaturation=>currentSaturation,
            :altitudeWindow=>window,
            :markerSize=>4,
            :showBestSaturation=>showBestSaturation,
            :showWorstSaturation=>showWorstSaturation
        });
        graph.draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function timerCallback() {
        var sensorHandler = SensorHandler.getInstance();

        currentSaturation = sensorHandler.getCurrentSaturation().value;
        currentAltitude = sensorHandler.getCurrentAltitude().value;

        System.println("Got sensor update");

        var aos = EquationUtils.getLinearTheoreticalSaturation(currentAltitude);
        aos = MathUtils.clamp(aos, 0, 100);
        
        oxygenSaturationText.setText(currentSaturation.format("%02d"));
        aosText.setText(aos.format("%02d"));

        WatchUi.requestUpdate();
    }
}

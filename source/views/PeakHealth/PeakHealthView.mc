import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.UserProfile;
import Toybox.Background;
import Toybox.Time;
import Toybox.Math;
import Toybox.Lang;
import EquationUtils;
import MathUtils;
import Toybox.Application.Storage;

class PeakHealthView extends WatchUi.View {

    hidden var oxygenSaturationText;
    hidden var aosText;
    hidden var graph;
    hidden var currentAltitude;
    hidden var currentSaturation;
    hidden var window as Lang.Number;

    function initialize() {
        View.initialize();

        Sensor.setEnabledSensors([Sensor.SENSOR_ONBOARD_PULSE_OXIMETRY]);
        Sensor.enableSensorEvents(method(:onSensorEvents));

        currentAltitude = 0;
        currentSaturation = EquationUtils.getLinearTheoreticalSaturation(currentAltitude);

        window = Storage.getValue("graph_altitude_window");
        if (window == null) {
            window = 1000;
        }
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        oxygenSaturationText = new WatchUi.Text({
            :text=>"000",
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_TOP
        });

        aosText = new WatchUi.Text({
            :text=>"000",
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM
        });

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
            :markerSize=>4
        });
        graph.draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function onSensorEvents(sensorInfo) {
        currentAltitude += 100;
        currentSaturation = EquationUtils.getPolynomialTheoreticalSaturation(currentAltitude);
        
        var mockAos = EquationUtils.getLinearTheoreticalSaturation(currentAltitude);
        mockAos = MathUtils.clamp(mockAos, 0, 100);
        
        oxygenSaturationText = new WatchUi.Text({
            :text=>currentSaturation.format("%02d"),
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_TOP
        });
        
        aosText = new WatchUi.Text({
            :text=>mockAos.format("%02d"),
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM
        });
        WatchUi.requestUpdate();
        return;

        if (sensorInfo == null) {
            System.println("SensorInfo was null");
            return;
        }

        var oxygenSaturation = sensorInfo.oxygenSaturation; 
        var altitude = sensorInfo.altitude;

        if (oxygenSaturation == null) {
            System.println("Got sensor update, oxygenSaturation was null");
            return;
        }

        if (altitude == null) {
            System.println("Got sensor update, altitude was null");
            return;
        }

        currentSaturation = oxygenSaturation;
        currentAltitude = altitude;

        System.println("Got sensor update");

        var aos = EquationUtils.getLinearTheoreticalSaturation(altitude);
        aos = MathUtils.clamp(aos, 0, 100);

        oxygenSaturationText = new WatchUi.Text({
            :text=>oxygenSaturation.format("%02d"),
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_TOP
        });

        aosText = new WatchUi.Text({
            :text=>aos.format("%02d"),
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM
        });

        WatchUi.requestUpdate();
    }
}

import Toybox.Graphics;
import Toybox.WatchUi;

class PeakHealthView extends WatchUi.View {

    hidden var oxygenSaturationText;
    hidden var debugText;
    hidden var updateCount;

    function initialize() {
        View.initialize();
        
        Sensor.setEnabledSensors([Sensor.SENSOR_ONBOARD_PULSE_OXIMETRY]);
        Sensor.enableSensorEvents(method(:onPulseOximetrySensor));

        updateCount = 0;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        oxygenSaturationText = new WatchUi.Text({
            :text=>"",
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });

        debugText = new WatchUi.Text({
            :text=>"hi",
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM
        });
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        oxygenSaturationText.draw(dc);
        debugText.draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }


    function onPulseOximetrySensor(sensorInfo) {
        if (sensorInfo == null) {
            System.println("SensorInfo was null");
            return;
        }

        if (sensorInfo.oxygenSaturation == null) {
            System.println("Got pulseoximetry update, oxygenSaturation was null");
            return;
        }

        System.println("Got pulseoximetry update");

        oxygenSaturationText = new WatchUi.Text({
            :text=>sensorInfo.oxygenSaturation.format("%02d"),
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });

        updateCount = updateCount + 1;

        debugText = new WatchUi.Text({
            :text=>updateCount.format("%d"),
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM
        });

        WatchUi.requestUpdate();
    }
}

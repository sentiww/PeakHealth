import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.UserProfile;

class PeakHealthView extends WatchUi.View {

    hidden var oxygenSaturationText;
    hidden var aosText;
    hidden var updateCount;

    function initialize() {
        View.initialize();
        
        Sensor.setEnabledSensors([Sensor.SENSOR_ONBOARD_PULSE_OXIMETRY]);
        Sensor.enableSensorEvents(method(:onSensorEvents));

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
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        oxygenSaturationText.draw(dc);
        aosText.draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function onSensorEvents(sensorInfo) {
        if (sensorInfo == null) {
            System.println("SensorInfo was null");
            return;
        }

        if (sensorInfo.oxygenSaturation == null) {
            System.println("Got pulseoximetry update, oxygenSaturation was null");
            return;
        }

        System.println("Got pulseoximetry update");

        var femaleModifier = 1.4;
        var maleModifier = 0.7;
        var unspecifiedModifier = (femaleModifier + maleModifier) / 2;  
        var genderModifier = -1;
        var userProfile = UserProfile.getProfile();
        if (userProfile == null or userProfile.gender == null) {
            genderModifier = unspecifiedModifier;
        }
        else if (userProfile.gender == UserProfile.GENDER_FEMALE) {
            genderModifier = femaleModifier;
        }
        else if (userProfile.gender == UserProfile.GENDER_MALE) {
            genderModifier = maleModifier;
        }
        System.println("Gender set correctly");

        var altitude = sensorInfo.altitude;

        var aos = 103.3 - (altitude * 0.0047) + (genderModifier);

        oxygenSaturationText = new WatchUi.Text({
            :text=>sensorInfo.oxygenSaturation.format("%02d"),
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

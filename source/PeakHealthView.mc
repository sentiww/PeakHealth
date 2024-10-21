import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.UserProfile;
import Toybox.Background;
import Toybox.Time;

class PeakHealthView extends WatchUi.View {

    hidden var oxygenSaturationText;
    hidden var aosText;

    function initialize() {
        View.initialize();

        Sensor.setEnabledSensors([Sensor.SENSOR_ONBOARD_PULSE_OXIMETRY]);
        Sensor.enableSensorEvents(method(:onSensorEvents));
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

        System.println("Got sensor update");

        var genderModifier = getGenderModifier();

        System.println("Gender set correctly");

        var aos = 103.3 - (altitude * 0.0047) + (genderModifier);

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
    
    function getGenderModifier() {
        var femaleModifier = 1.4;
        var maleModifier = 0.7;
        var unspecifiedModifier = (femaleModifier + maleModifier) / 2;
        
        var userProfile = UserProfile.getProfile();
        
        if (userProfile == null or userProfile.gender == null) {
            return unspecifiedModifier;
        }
        else if (userProfile.gender == UserProfile.GENDER_FEMALE) {
            return femaleModifier;
        }
        else if (userProfile.gender == UserProfile.GENDER_MALE) {
            return maleModifier;
        }

        return unspecifiedModifier;
    }
}

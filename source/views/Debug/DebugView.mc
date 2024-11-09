import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.UserProfile;

class DebugView extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({
            :title=>"Debug"
        });

        var currentAltitudeText = getCurrentAltitudeText();
        var currentAltitude = new MenuItem(
            "Current altitude",
            currentAltitudeText,
            "",
            {}
        );

        var currentSaturationText = getCurrentSaturationText();
        var currentSaturation = new MenuItem(
            "Current saturation",
            currentSaturationText,
            "",
            {}
        ); 

        var userGenderText = getUserGenderText();
        var userGender = new MenuItem(
            "User gender",
            userGenderText,
            "",
            {}
        );

        var menuItems = [
            currentAltitude,
            currentSaturation,
            userGender
        ] as Array<MenuItem>;

        for (var index = 0; index < menuItems.size(); index++) {
            var menuItem = menuItems[index];
            self.addItem(menuItem);
        }
    }

    function getCurrentAltitudeText() {
        var sensorHandler = SensorHandler.getInstance();

        var currentAltitude = sensorHandler.getCurrentAltitude();

        return currentAltitude.value + "m, at " + MomentUtils.toHumanReadable(currentAltitude.moment);
    }

    function getCurrentSaturationText() {
        var sensorHandler = SensorHandler.getInstance();

        var currentSaturation = sensorHandler.getCurrentSaturation();

        return currentSaturation.value + "%, at " + MomentUtils.toHumanReadable(currentSaturation.moment);
    }

    function getUserGenderText() {
        var userProfile = UserProfile.getProfile();

        if (userProfile == null or userProfile.gender == null) {
            return "Unspecified";
        }
        else if (userProfile.gender == UserProfile.GENDER_FEMALE) {
            return "Female";
        }
        else if (userProfile.gender == UserProfile.GENDER_MALE) {
            return "Male";
        }

        return "Unspecified";
    }

}
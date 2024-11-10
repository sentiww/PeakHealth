import Toybox.UserProfile;
import Toybox.Math;
import Toybox.Lang;

public module EquationUtils {
 
    public function getGenderModifier() as Numeric {
        var femaleModifier = 1.4;
        var maleModifier = 0.7;
        var unspecifiedModifier = (femaleModifier + maleModifier) / 2;
        
        var userProfile = UserProfile.getProfile();
        
        if (userProfile == null or userProfile.gender == null) {
            return unspecifiedModifier;
        }
        
        if (userProfile.gender == UserProfile.GENDER_FEMALE) {
            return femaleModifier;
        }
        
        if (userProfile.gender == UserProfile.GENDER_MALE) {
            return maleModifier;
        }

        return unspecifiedModifier;
    }

    public function getLinearTheoreticalSaturation(altitude as Numeric) as Numeric {
        var genderModifier = getGenderModifier();
        return 103.3 - altitude * 0.0047 + genderModifier;
    }

    public function getPolynomialTheoreticalSaturation(altitude as Numeric) as Numeric {
        return 97.51774 + 0.0002783871 * altitude - 7.864516 * Math.pow(10, -7) * altitude * altitude;
    }

}
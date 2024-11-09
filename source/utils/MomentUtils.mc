import Toybox.Time;
import Toybox.System;
import Toybox.Lang;
import Toybox.Time.Gregorian;

public module MomentUtils {

    public function toHumanReadable(moment as Moment) {
        var offset = moment.value();

        offset -= System.getClockTime().timeZoneOffset;

        var offsetMoment = new Moment(offset);

        var info = Gregorian.info(offsetMoment, Time.FORMAT_SHORT);

        return Lang.format("$1$-$2$-$3$T$4$:$5$:$6$Z", [
            info.year,
            info.month.format("%02d"),
            info.day.format("%02d"),
            info.hour.format("%02d"),
            info.min.format("%02d"),
            info.sec.format("%02d")
        ]);
    }

}
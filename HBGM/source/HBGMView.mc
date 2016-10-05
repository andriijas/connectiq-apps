using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;

class HBGMView extends Ui.WatchFace {

    function initialize() {
         WatchFace.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        var now = Time.now();
        var HbgmMoment = Calendar.moment({
            :year => 2017,
            :month => 9,
            :day => 2,
            :hour => 10,
            :minute => 0,
            :second => 0
        });
        var HbgmEndMoment = Calendar.moment({
            :year => 2017,
            :month => 9,
            :day => 2,
            :hour => 12,
            :minute => 0,
            :second => 0
        });

        // Do some magic timezone offset bonanza
        HbgmMoment = HbgmMoment.add(new Time.Duration(-Sys.getClockTime().timeZoneOffset));

        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        var date = Calendar.info(now, Time.FORMAT_MEDIUM);

        // ### Time ###

        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        }
        View.findDrawableById("TimeLabel")
            .setText(Lang.format("$1$:$2$", [hours, clockTime.min.format("%02d")]));

        // ### /Time ###

        // ### Date ###

        View.findDrawableById("DateLabel")
            .setText(Lang.format("$1$ $2$ $3$", [date.day_of_week, date.day, date.month]));

        // ### /Date ###

        // ### Countdown ###

        var remaining = HbgmMoment.subtract(now).value();
        var hoursLeft = remaining / Calendar.SECONDS_PER_HOUR;
        var minutesLeft = (remaining / 60 ) % 60;
        var daysLeft =  remaining / Calendar.SECONDS_PER_DAY;
        var weeksLeft = daysLeft / 7;

        var countDownLabelText = "";
        if (now.lessThan(HbgmMoment)) {
            if (daysLeft == 300 || daysLeft == 250 || daysLeft == 200 || daysLeft == 150) {
                countDownLabelText = Lang.format("$1$d", [daysLeft]);
            } else if (daysLeft >= 100) {
                countDownLabelText = Lang.format("$1$w", [weeksLeft]);
            } else if (daysLeft > 0) {
                countDownLabelText = Lang.format("$1$d", [daysLeft]);
            } else if (hoursLeft > 0) {
               countDownLabelText = Lang.format("$1$h", [hoursLeft]);
            } else if (minutesLeft > 0) {
               countDownLabelText = Lang.format("$1$m", [minutesLeft]);
            }
        }
        View.findDrawableById("CountDownLabel").setText(countDownLabelText);

        if (hoursLeft < 24 and now.lessThan(HbgmEndMoment)) {
           View.findDrawableById("goodluck")
            .setText("HAVE A\nNICE\nRACE!");
         }

        // ### /Countdown ###


        drawActivity(dc);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }


    function drawActivity(dc) {
        var history = ActivityMonitor.getHistory();
        var activity = ActivityMonitor.getInfo();
        var deviceSettings = Sys.getDeviceSettings();

        var distanceToday = activity.distance.toFloat();
        var distanceWeek = distanceToday + 0;

        var unit;

        // Sum distance last week
        for( var i = 0; i < history.size(); i++ ) {
            distanceWeek += history[i].distance.toFloat();
        }

        if (deviceSettings.distanceUnits == deviceSettings.UNIT_STATUTE) {
            distanceToday = distanceToday / 160934;
            distanceWeek  = distanceWeek / 160934;
            unit = "mi";
         } else {
            distanceToday = distanceToday / 100000;
            distanceWeek  = distanceWeek / 100000;
            unit = "km";
         }

        View.findDrawableById("ActivitySteps").setText(Lang.format("$1$", [activity.steps]));
        View.findDrawableById("ActivityToday").setText(Lang.format("$1$$2$", [formatDistance(distanceToday), unit]));
        View.findDrawableById("ActivityWeek").setText(Lang.format("$1$$2$", [formatDistance(distanceWeek), unit]));
    }

    function formatDistance(distance) {
         if(distance < 100) {
            return distance.format("%2.1f");     // formatting km/mi to 2numbers + 1 digit
        } else {
            return distance.format("%3u");
        }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}

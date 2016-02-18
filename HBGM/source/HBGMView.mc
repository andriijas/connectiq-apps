using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;

class HBGMView extends Ui.WatchFace {

    var width, height;

    function initialize() {
         WatchFace.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        width = dc.getWidth();
        height = dc.getHeight();
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
            :year => 2016,
            :month => 9,
            :day => 3,
            :hour => 10,
            :minute => 0,
            :second => 0
        });

        // Do some magic timezone offset bonanza, like a baws
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

        View.findDrawableById("DateDayLabel")
            .setText(Lang.format("$1$", [date.day_of_week]));
        View.findDrawableById("DateLabel")
            .setText(Lang.format("$1$ $2$", [date.day, date.month]));

        // ### /Date ###

        // ### Countdown ###

        var remaining = HbgmMoment.subtract(now).value();
        var min  = (remaining % Calendar.SECONDS_PER_HOUR) / Calendar.SECONDS_PER_MINUTE;
        var hour = (remaining % Calendar.SECONDS_PER_DAY) / Calendar.SECONDS_PER_HOUR;
        var day =  remaining / Calendar.SECONDS_PER_DAY;

        //var countDownText = Lang.format("$1$d $2$:$3$", [
        //    day,
        //    hour.format("%02d"),
        //    min.format("%02d")
        //]);

        View.findDrawableById("CountDownLabel").setText(Lang.format("$1$", [day]));

        // ### /Countdown ###

        View.findDrawableById("battery")
            .setLevel(System.getSystemStats().battery);


        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
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

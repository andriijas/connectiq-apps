using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Lang as Lang;

class MFFWatchView extends Ui.WatchFace {

    //! Load your resources here
    function onLayout(dc) {
       View.setLayout(Rez.Layouts.MainLayout(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        var moment = Time.now();
        var info = Gregorian.info(moment, Time.FORMAT_MEDIUM);
        var clockTime = Sys.getClockTime();

        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%.2d")]);
        View.findDrawableById("time").setText(timeString);

        var dateString = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.day, info.month]);
        View.findDrawableById("date").setText(dateString);

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

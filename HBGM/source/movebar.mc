using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as Act;

class MoveBar extends Ui.Drawable
{
    hidden var x, y;

    function initialize(options) {
        x = options[:x];
        y = options[:y];
        Drawable.initialize(options);
    }

    function draw(dc) {
        var settings = Sys.getDeviceSettings();
        var activity = Act.getInfo();
        var w = settings.screenWidth/2;
        var h = settings.screenHeight/2;

        // No rectangle support for now
        if (settings.screenShape == Sys.SCREEN_SHAPE_RECTANGLE) {
            return;
        }

        // Draw nothing, if there is nothing to draw. Simple equation huh?
        if (activity.moveBarLevel == Act.MOVE_BAR_LEVEL_MIN) {
            return;
        }

        dc.setPenWidth(3);
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED);

        dc.drawArc(w, h, w, Gfx.ARC_COUNTER_CLOCKWISE, 182, 210);

        if (activity.moveBarLevel == Act.MOVE_BAR_LEVEL_MIN+1) {
            return;
        }

        var s = 180;
        for( var i = Act.MOVE_BAR_LEVEL_MIN+1; i < activity.moveBarLevel; i++ ) {
            dc.drawArc(w, h, w, Gfx.ARC_COUNTER_CLOCKWISE, s-6, s);
            s-=8;
        }

    }
}

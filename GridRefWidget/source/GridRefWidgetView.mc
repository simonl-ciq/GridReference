using Toybox.WatchUi as Ui;
//using Toybox.System as Sys;
using Toybox.Position;
using Toybox.Application as App;
using Toybox.Application.Properties as Props;
using GridRefClasses as GridRef;


class GridRefWidgetView extends Ui.View {
    hidden var mLocation;
    hidden var mDigits;
    hidden var mAccuracy = 0;
    hidden var updatingGPS = false;

    function initialize() {
        View.initialize();

        mAccuracy = 0;
        updatingGPS = false;
        
		if ( App has :Properties ) {
	        mDigits = Props.getValue("Digits");
	    } else {
	        mDigits = App.getApp().getProperty("Digits");
	    }
    }

    // Load your resources here
    function onLayout(dc) {
        updatingGPS = false;
		View.setLayout(Rez.Layouts.MainLayout(dc));
        var titleView = View.findDrawableById("title");
       	titleView.setText("Grid Reference");
        var valueView = View.findDrawableById("value");
       	valueView.setText("No GPS Data");
		var labelView = View.findDrawableById("label");
        labelView.setText(Rez.Strings.label);
        var accView = View.findDrawableById("accuracy");
        accView.locX = labelView.locX + 4;
        accView.setText(Rez.Strings.accuracy);
    }

    /* ======================== Position handling ========================== */

    function onPosition(info) {
        if ( info != null ) {
	        mAccuracy = (info has :accuracy && info.accuracy != null && info.accuracy > 1) ? info.accuracy : 0;
    		mLocation = info.position;
		}
        Ui.requestUpdate();
    }

    function updateToggle() {
        if (updatingGPS == true) {
	    	Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
	    	updatingGPS = false;
        } else {
    	    Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
	        updatingGPS = true;
    	}
    	Ui.requestUpdate();
    }
    
    function updatePosition() {
        if (updatingGPS == true) {
            return;
        }
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        updatingGPS = true;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
		updatePosition();
    }

    function doCompute() {

//    	mLocation = Position.parse("53.825564, -2.421976", Position.GEO_DEG);
//    	mLocation = Position.parse("253.825564, -24.421976", Position.GEO_DEG);

    	return (mLocation != null && mAccuracy > 1) ? GridRef.OSGridString(mLocation.toRadians(), mDigits) : "No GPS Data";
    }

    // Update the view
    function onUpdate(dc) {
	    var GPS = ["None", "Last", "Poor", "Usable", "Good"];
	    var acc;

//    	mAccuracy = 2;

		if (updatingGPS == false) {
			acc = "Fixed";
		} else {
    	   	acc = GPS[mAccuracy];
       		View.findDrawableById("value").setText(doCompute());
       	}
   		View.findDrawableById("accuracy").setText(acc);
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        updatingGPS = false;
    }

}

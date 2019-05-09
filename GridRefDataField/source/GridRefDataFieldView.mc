using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application as App;
using Toybox.Application.Properties as Props;
using GridRefClasses as GridRef;

class GridRefDataFieldView extends WatchUi.DataField {
    hidden var mDigits;
    hidden var mString = "";

    // Set the label of the data field here.
    function initialize() {
        DataField.initialize();

		if ( App has :Properties ) {
	        mDigits = Props.getValue("Digits");
	    } else {
	        mDigits = App.getApp().getProperty("Digits");
	    }

    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc) {
    
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout - 3
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout - 6
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Top sector so we'll use the generic, centered layout shifted - 7
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopCentreLayout(dc));

        // Middle sector so we'll use the generic, centered layout shrunk - 5
        } else if (obscurityFlags == (OBSCURE_LEFT | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.MiddleCentreLayout(dc));

        // Middle sector left so we'll use the generic, centered layout shrunk - 1
        } else if (obscurityFlags == (OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.MiddleLeftLayout(dc));

        // Middle sector so we'll use the generic, centered layout shrunk - 4
        } else if (obscurityFlags == (OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.MiddleRightLayout(dc));

        // Bottom sector so we'll use the generic, centered layout upside down - 13
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomCentreLayout(dc));
            var labelView = View.findDrawableById("label");
	        var height = dc.getHeight();
            labelView.locY = height - 32;

        // Bottom left quadrant so we'll use the bottom left layout - 9
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout - 12
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
        }

        View.findDrawableById("label").setText(Rez.Strings.label);

        return true;
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
		var Accuracy = 2;
//		    Accuracy = 1; // for testing / debugging
		
		mString = "No GPS Data";

	    if (info has :currentLocationAccuracy && info.currentLocationAccuracy != null) {
	    	Accuracy = info.currentLocationAccuracy;
	    }
		if (info has :currentLocation && info.currentLocation != null && Accuracy > 1) {
    		mString = GridRef.OSGridString(info.currentLocation.toRadians(), mDigits);
	    }
//   for testing / debugging
/*
	      else {
    		mString = GridRef.OSGridString([0.939433, -0.042271], 8);
	  	}
*/
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) {
        // Set the background color
        View.findDrawableById("Background").setColor(getBackgroundColor());

        var labelView = View.findDrawableById("label");

        // Set the foreground color and value
        var valueView = View.findDrawableById("value");
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            valueView.setColor(Graphics.COLOR_WHITE);
        } else {
            valueView.setColor(Graphics.COLOR_BLACK);
        }

        var obscurityFlags = DataField.getObscurityFlags();
        // Main layout
        if (obscurityFlags == 0 || obscurityFlags == 15) {
	        var height = dc.getHeight();
            var width = dc.getWidth();
        	var f = 4;
        	var w = 0;
        	while (f > 0) {
	        	w = dc.getTextWidthInPixels(mString, f);
        		if (w <= width) {
	        		break;
        		}
        		f = f-1;
        	}
	        valueView.setFont(f);
	        valueView.locY = height / 2 - 8;
        }
        
        valueView.setText(mString);

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

}

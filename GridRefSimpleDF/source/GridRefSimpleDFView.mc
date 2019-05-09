using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Application as App;
using Toybox.Application.Properties as Props;
using GridRefClasses as GridRef;

class GridRefSimpleDFView extends Ui.SimpleDataField {
    hidden var mDigits;

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = "Grid Ref";

		if ( App has :Properties ) {
	        mDigits = Props.getValue("Digits");
	    } else {
	        mDigits = App.getApp().getProperty("Digits");
	    }
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
		var Accuracy = 2;
//		    Accuracy = 1; // for testing / debugging
		var String = "No GPS Data";

	    if (info has :currentLocationAccuracy && info.currentLocationAccuracy != null) {
	    	Accuracy = info.currentLocationAccuracy;
	    }
		if (info has :currentLocation && info.currentLocation != null && Accuracy > 1) {
    		String = GridRef.OSGridString(info.currentLocation.toRadians(), mDigits);
	    }
//   for testing / debugging
/*
	      else {
    		String = GridRef.OSGridString([0.939433, -0.042271], 8);
	  	}
*/
    	return String;
    }
}
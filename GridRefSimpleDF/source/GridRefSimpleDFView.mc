using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Application.Properties as Props;
using Toybox.System as Sys;
using Toybox.Position;

using GridRefClasses as GridRef;

const cDigits = 6;
const cGrid = 0; // OS GB grid by default
const cBestGuess = true;

const OutSide = "Outside Grid";
const NoData = "No GPS Data";

class GridRefSimpleDFView extends Ui.SimpleDataField {
    hidden var mDigits = cDigits;
    hidden var mGrid = cGrid;
    hidden var mBestGuess = cBestGuess;
    
    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = "Grid Ref";
        var temp;

		if ( App has :Properties ) {
	        mDigits = Props.getValue("Digits");
	        mGrid = Props.getValue("DefaultGrid");
	        temp = Props.getValue("BestGuess");
	    } else {
	        mDigits = App.getApp().getProperty("Digits");
	        mGrid = App.getApp().getProperty("DefaultGrid");
	        temp = App.getApp().getProperty("BestGuess");
	    }
	    if (mDigits == null) {mDigits = cDigits;}
	    if (mGrid == null) {mGrid = cGrid;}
	    if (temp == null) {
	    	mBestGuess = cBestGuess;
	    } else {
	    	mBestGuess = (temp == 0);
	    }
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
		var Accuracy = 2;
//		    Accuracy = 1; // for testing / debugging
		var String = NoData;

	    if (info has :currentLocationAccuracy && info.currentLocationAccuracy != null) {
	    	Accuracy = info.currentLocationAccuracy;
	    }
		if (info has :currentLocation && info.currentLocation != null && Accuracy > 1) {
			var useGrid = mGrid;
			var rads = info.currentLocation.toRadians();
//rads = Position.parse("54.479613, -6.6991577", Position.GEO_DEG).toRadians();
//   0.968 is 55.462315 degrees North, (Tor Rocks north of Inishtrahull) further North is treated as GB
//  -0.093 is 5.328507 degrees West (East of Cannon Rock), further East is treated as GB
//   0.896 is 51.337021 degrees North, (Fastnet Rock) further South is treated as GB
//   0.963, -0.102 55.175835, -5.844170 SW of Mull of Kintyre
//   0.908, -0.102, > 52.024567, -5.844170 NW of St David's Head
// By default, unless otherwise set, try Ireland first unless too far east or north. In the overlap the chosen default grid will be used.
			if (mBestGuess) {
				if (rads[1] > -0.093 || rads[0] > 0.968 || rads[0] < 0.896) { useGrid = 0; } else
				if (rads[1] > -0.102 && (rads[0] > 0.963 || rads[0] < 0.908)) { useGrid = 0; }
				else { useGrid = 1; }
			}
			var gr = GridRef.OSGridArray(useGrid, rads, mDigits);
			if (gr[0].equals(OutSide)) {
// Try the other grid if outside the 1st one (shouldn't happen with BestGuess)
				gr = GridRef.OSGridArray(((useGrid + 1) % 2), rads, mDigits);
			}
	    	String = gr[0];
			if (!gr[0].equals(OutSide)) {
		    	String += (" " + gr[1] + " " + gr[2]);
		    }
	    }
    	return String;
    }
}
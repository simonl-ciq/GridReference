using Toybox.WatchUi as Ui;
using Toybox.Position;
using Toybox.Application as App;
using Toybox.Application.Properties as Props;
using Toybox.Graphics;
using Toybox.System as Sys;
using GridRefClasses as GridRef;

class GridRefWidgetView extends Ui.View {

const cDigits = 6;
const cGrid = 0; // OS GB grid by default
const cBestGuess = true;
const cSize = 0;

const OutSide = "Outside Grid";
const NoData = "No GPS Data";

	hidden var mLocation;
	hidden var mDigits = cDigits;
	hidden var mGrid = cGrid;
    hidden var mBestGuess = cBestGuess;
	hidden var mSize = cSize;
	hidden var mAccuracy = 0;
	hidden var mLaidOut = false;
	hidden var updatingGPS = false;
	hidden var lpLocY, vlLocY;
	
	var mScreenShape;
	var mOptions;

	function getSettings() {
		var temp;
        if ( App has :Properties ) {
	        mDigits = Props.getValue("Digits");
	        mGrid = Props.getValue("DefaultGrid");
	        temp = Props.getValue("BestGuess");
	        mSize = Props.getValue("FontSize");
	    } else {
	        mDigits = App.getApp().getProperty("Digits");
	        mGrid = App.getApp().getProperty("DefaultGrid");
	        temp = App.getApp().getProperty("BestGuess");
	        mSize = App.getApp().getProperty("FontSize");
	    }
	    if (mDigits == null) {mDigits = cDigits;}
	    if (mGrid == null) {mGrid = cGrid;}
	    if (temp == null) {
	    	mBestGuess = cBestGuess;
	    } else {
	    	mBestGuess = (temp == 0);
	    }
	    if (mSize == null) {mSize = cSize;}
	    mLaidOut = false;
	}

	function initialize() {
		View.initialize();
		
		var temp = Sys.getDeviceSettings();
		mScreenShape = temp.screenShape;
		temp = temp.monkeyVersion;
       	mOptions = ((temp[0]*100 + temp[1]*10 + temp[2]) >= 320) ? {:acquisitionType => Position.LOCATION_CONTINUOUS,
						 :constellations => [ Position.CONSTELLATION_GPS, Position.CONSTELLATION_GLONASS ]
						} : Position.LOCATION_CONTINUOUS;

		getSettings();
	
		mAccuracy = 0;
		updatingGPS = false;
	}

    // Load your resources here
	function doLayout(dc) {
		if (mSize == 0) { // one line
			View.setLayout(Rez.Layouts.MainLayout(dc));
		} else if (mSize == 1) { // two line
			if (mDigits == 4) {
				View.setLayout(Rez.Layouts.MainLayout4(dc));
			} else if (mDigits == 6) {
				View.setLayout(Rez.Layouts.MainLayout6(dc));
			} else if (mDigits == 8) {
				View.setLayout(Rez.Layouts.MainLayout8(dc));
			} else { //mDigits == 10
				View.setLayout(Rez.Layouts.MainLayout10(dc));
			}
		} else { // mSize == 2 - three line
			if (mScreenShape == Sys.SCREEN_SHAPE_RECTANGLE || mDigits < 10 ) {
				View.setLayout(Rez.Layouts.MainLayoutL(dc));
			} else { //mDigits == 10
				View.setLayout(Rez.Layouts.MainLayout10L(dc));
				if (View.findDrawableById("title") == null) {
					View.setLayout(Rez.Layouts.MainLayoutL(dc));
				}
			}
		}
		var tmpView = View.findDrawableById("title");
		tmpView.setText("Grid Reference");
		var vleView = View.findDrawableById("valueE");
		if (mSize != 0) { // not one line
			vleView.setText("");
			var vlnView = View.findDrawableById("valueN");
			vlnView.setText("");
			vlLocY = vleView.locY;
			tmpView = View.findDrawableById("letters");
			if (mScreenShape == Sys.SCREEN_SHAPE_RECTANGLE) {
				if (mSize == 2) { // three line
					vlLocY -= 20; // move the whole thing up a bit
					vleView.locY = vlLocY;
					vlnView.locY += vlLocY;
				}
				lpLocY = vlLocY - tmpView.locY;
			} else { // not rectangle
				lpLocY = tmpView.locY;
			}
		}
		vleView.setText(NoData);
		var labelView = View.findDrawableById("label");
		labelView.setText(Rez.Strings.label);
		tmpView = View.findDrawableById("accuracy");
		tmpView.locX = labelView.locX + 4;
		tmpView.setText(Rez.Strings.accuracy);
	    mLaidOut = true;
	}

	function onLayout(dc) {
// I can't remember why I (had to?) put this line here - better leave it.	
		updatingGPS = false;
		doLayout(dc);
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
    	    Position.enableLocationEvents(mOptions, method(:onPosition));
	        updatingGPS = true;
    	}
    	Ui.requestUpdate();
    }
    
    function updatePosition() {
        if (updatingGPS == true) {
            return;
        }
   	    Position.enableLocationEvents(mOptions, method(:onPosition));
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
//    	mLocation = Position.parse("53.32, -6.66", Position.GEO_DEG);
		if ((mLocation == null || mAccuracy <= 1)) {return [NoData, "", ""];}
		var useGrid = mGrid;
		var rads = mLocation.toRadians();
//rads = Position.parse("54.479613, -5.6991577", Position.GEO_DEG).toRadians(); //in overlap
//rads = Position.parse("53.2839935, -9.1189576", Position.GEO_DEG).toRadians(); // Galway
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
		return gr;
    }

    // Update the view
    function onUpdate(dc) {
	    var GPS = ["None", "Last", "Poor", "Usable", "Good"];
	    var acc;
	    
	    if (!mLaidOut) { 
	    	doLayout(dc);
	    }

		if (updatingGPS == false) {
			acc = "Fixed";
		} else {
			acc = GPS[mAccuracy];
			var gr = doCompute();
			if (mSize == 0) {
				if (gr[0].equals(NoData) || gr[0].equals(OutSide)) {
					View.findDrawableById("valueE").setText(gr[0]);
				} else {
					View.findDrawableById("valueE").setText(gr[0] + " " + gr[1] + " " + gr[2]);
				}
			} else {
				var txt = View.findDrawableById("letters");
				if (gr[0].equals(NoData) || gr[0].equals(OutSide)) {
					txt.locY = vlLocY;
				} else {
					txt.locY = lpLocY;
				}
				txt.setText(gr[0]);
//gr[1] = "289"; gr[2] = "377";
				View.findDrawableById("valueE").setText(gr[1]);
//	View.findDrawableById("valueE").setText("74277");
				View.findDrawableById("valueN").setText(gr[2]);
//	View.findDrawableById("valueN").setText("24272");
			}
			
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

(:glance)
class GridRefWidgetGlanceView extends Ui.GlanceView {

	function initialize() {
		GlanceView.initialize();
	}

	function onUpdate(dc) {
		dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_BLACK);
		dc.clear();
		dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
		dc.drawText(0, 15, Graphics.FONT_SMALL,"Grid Reference", Graphics.TEXT_JUSTIFY_LEFT);
	}
}

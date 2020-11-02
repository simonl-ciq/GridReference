//using Toybox.System;
//using Toybox.Test;
using Toybox.Position;

(:test)
function testNoGPS(logger) {
	var view = new GridRefWidgetMock();
	
// A geographical centre of GB - near Whalley (mainland only)
// 53.825564, -2.421976,
// Another, at Whitendale Hanging Stones, Dunsop Bridge (includes some nearby islands)
// 54.003644, -2.547859

	view.setLocation (Position.parse("53.825564, -2.421976", Position.GEO_DEG));
	
	view.setAccuracy(0);
	var str = view.doCompute();
    logger.debug(str);
    if (str.equals("No GPS Data")) {
	   	return true;
	} else {
		return false;
	}
}

(:test)
function testGoodGPS(logger) {
	var view = new GridRefWidgetMock();

	view.setLocation (Position.parse("53.825564, -2.421976", Position.GEO_DEG));
	view.setAccuracy(3);
	var str = view.doCompute();
    logger.debug(str);
    if (str.equals("SD 723 366")) {
	   	return true;
	} else {
		return false;
	}
}

(:test)
function testOutside(logger) {
	var view = new GridRefWidgetMock();

	view.setLocation (Position.parse("53.825564, -52.421976", Position.GEO_DEG)); // Outside the OS Grid
	view.setAccuracy(1);
	var str = view.doCompute();
    logger.debug(str);
    if (str.equals("Outside Grid")) {
	   	return true;
	} else {
		return false;
	}
}

(:test)
function testToggle(logger) {
	var view = new GridRefWidgetMock();
	var del = new GridRefWidgetDelegate(view);

	var upd0 = view.getupdatingGPS();
    logger.debug(upd0);
    Toybox.Test.assertMessage(!upd0, "Not initially updating position");
    
	del.onMenu();
	var upd1 = view.getupdatingGPS();
    logger.debug(upd1);

    if (upd0 == upd1) {
		return false;
	}

	del.onMenu();
	var upd2 = view.getupdatingGPS();
    logger.debug(upd2);

    if (upd0 == upd2) {
		return true;
	} else {
		return false;
	}
}

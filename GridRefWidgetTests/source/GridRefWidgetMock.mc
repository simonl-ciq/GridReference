using Toybox.WatchUi as Ui;

class GridRefWidgetMock extends GridRefWidgetView {
//    hidden var mLocation;
//    hidden var mAccuracy = 0;
//    hidden var updatingGPS = false;

    function initialize() {
        GridRefWidgetView.initialize();
    }

    function getLocation () {
        return mLocation;
    }

    function setLocation (loc) {
        mLocation = loc;
    }

    function getAccuracy () {
        return mAccuracy;
    }

    function setAccuracy (acc) {
        mAccuracy = acc;
    }

    function getupdatingGPS () {
        return updatingGPS;
    }

    function setupdatingGPS (updGPS) {
        updatingGPS = updGPS;
    }

}

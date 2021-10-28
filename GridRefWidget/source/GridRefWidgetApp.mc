using Toybox.Application as App;
using Toybox.WatchUi;

class GridRefWidgetApp extends App.AppBase {
	hidden var GRView;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        GRView = new GridRefWidgetView();
        return [ GRView, new GridRefWidgetDelegate(GRView) ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
    	if (GRView != null) {
			GRView.getSettings();
    	    WatchUi.requestUpdate();
    	}
    }

(:glance)
    function getGlanceView() {
        return [ new GridRefWidgetGlanceView() ];
    }
}
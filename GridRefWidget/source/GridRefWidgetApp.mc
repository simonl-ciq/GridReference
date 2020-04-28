using Toybox.Application as App;

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

(:glance)
    function getGlanceView() {
        return [ new GridRefWidgetGlanceView() ];
    }
}
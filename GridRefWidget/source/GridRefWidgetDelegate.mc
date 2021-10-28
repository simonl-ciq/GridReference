using Toybox.WatchUi as Ui;

class GridRefWidgetDelegate extends Ui.BehaviorDelegate {
    var GRWview;

    /* Initialize and get a reference to the view, so that
     * user iterations can call methods in the main view. */
    function initialize(view) {
        Ui.BehaviorDelegate.initialize();
        GRWview = view;
    }

    /* Menu button press. */
    function onMenu() {
        GRWview.updateToggle();
        return true;
    }

}

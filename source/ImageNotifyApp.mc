using Toybox.Application as App;

class ImageNotifyApp extends App.AppBase {
    hidden var mDelegate;
    hidden var mView;

    //! onStart() is called on application start up
    function onStart(state) {
        mView = new ImageNotifyView(-1, 0);
        mDelegate = new ImageNotifyDelegate(0, mView.method(:onReceive));
    }

    //! onStop() is called when your application is exiting
    function onStop(state) {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ mView, mDelegate ];
    }
	function initialize() {
		AppBase.initialize();
	}
}
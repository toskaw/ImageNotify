using Toybox.WatchUi as Ui;
using Toybox.Communications as Comm;
using Toybox.Attention as Attention;
using Toybox.System as Sys;

class ImageNotifyDelegate extends Ui.BehaviorDelegate
{
	hidden var size;
	hidden var notify;

	function initialize(s, handler) {
        Ui.BehaviorDelegate.initialize();
        size = s;
        notify = handler;
        Comm.setMailboxListener( method(:onMail) );
    }

    function onKey(evt) {
        var key = evt.getKey();
 		if ( key == KEY_ENTER ) {
    		Comm.makeJsonRequest(
            	"http://127.0.0.1:8080/",
				{},
				{
               		"Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED
            	},
            	method(:onReceive)
        	);
 			return true;
 		}
 	
        return Ui.BehaviorDelegate.onKey(evt); 
    }
    
    function onReceive(responseCode, data) {
        if( responseCode == 200 ) {
        	size = data["count"].toNumber();
 			notify.invoke(size);
        }
        else {
            size = 0;
            notify.invoke(0);
        }
    }
    
    function onMail(mailIter)
    {
    	Comm.makeJsonRequest(
			"http://127.0.0.1:8080/",
			//"http://webserver/~user/test.html",
			{},
			{
            	"Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED
            },
            method(:onReceive)
        );
        Comm.emptyMailbox();
    }

}

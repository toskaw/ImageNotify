using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Communications as Comm;
using Toybox.System as Sys;

class ImageNotifyView extends Ui.View {
	var size;
	var status  = -1;
	var bitmap;
	var index;
	var x;
	var y;
	var width;
	var height;
	
    hidden var paletteTEST=[
    	0xFF000000, 
     	0xFF555555,
    	0xFFAAAAAA,
	   	0xFFFFFFFF
    ];	
    
    function initialize(i, s) {
    	index = i;
    	size = s;
    	View.initialize();
    }
    //! Load your resources here
    function onLayout(dc) {
        width = dc.getWidth();
        height = dc.getHeight();
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        if (status == 0) {
        	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        	dc.clear();
        	if (bitmap != null) {
        		x = (dc.getWidth() - bitmap.getWidth()) / 2;
        		y = (dc.getHeight() - bitmap.getHeight()) / 2;
        	    dc.drawBitmap(x, y,bitmap);
        	    System.println(x.toString() + "," + y.toString());
				//dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Gfx.FONT_MEDIUM, bitmap.getWidth()+"/"+ bitmap.getHeight() , Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        	}
        	dc.drawText(50, dc.getHeight() - 50, Gfx.FONT_MEDIUM, "Loading", Gfx.TEXT_JUSTIFY_LEFT);
        	drawIndicator(dc, index);
        }
        else if (status == 1) {
        	dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_WHITE );
        	dc.clear();
        	if (bitmap != null) {
         		x = (dc.getWidth() - bitmap.getWidth()) / 2;
        		y = (dc.getHeight() - bitmap.getHeight()) / 2;
        	    dc.drawBitmap(x, y,bitmap);
         	    System.println(x.toString() + "," + y.toString());
 				//dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Gfx.FONT_MEDIUM, bitmap.getWidth()+"/"+ bitmap.getHeight() , Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        	}
        	drawIndicator(dc, index);
        }
        else if (status == -1) {
         	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        	dc.clear();
        	dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - 15, Gfx.FONT_MEDIUM, "No Data", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        	dc.drawText(dc.getWidth()/2, dc.getHeight()/2 + 15, Gfx.FONT_MEDIUM, "Press Enter", Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
         	drawIndicator(dc, index);
        }
        
    }
    
    function drawIndicator(dc, selectedIndex) {
        dc.drawText(dc.getWidth() - 50, dc.getHeight() - 50, Gfx.FONT_MEDIUM, (index + 1)+"/"+size, Gfx.TEXT_JUSTIFY_RIGHT);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }
    
    function requestImage() {
    	if (size == 0) {
    		status = -1;
    		return;
    	}
    	index = (index + 1) % size;
        //bitmap = null;
        status = 0;
        Comm.makeImageRequest(
            "http://127.0.0.1:8080/",
			{"id" => index},
			{
                :palette=>paletteTEST,
                :maxWidth=>width,
                :maxHeight=>height
            },
            method(:onReceiveImage)
        );
    }
    function onReceive(s) {
    	if (size != s) {
        	size = s;
        	index = -1;
        }
        requestImage();
        Ui.requestUpdate();
    }
    
    function onReceiveImage(responseCode, data) {
        if( responseCode == 200 ) {
        	bitmap = data;
        	status = 1;
        	Ui.requestUpdate();
        }
        else {
        	status = -1;
        	index = -1; 
        	size = 0;      	
        	Ui.requestUpdate(); 
         }
    }

}

package {
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.NetStatusEvent;
    import flash.net.SharedObject;
    import flash.net.SharedObjectFlushStatus;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
	import 	flash.net.SharedObject;
    
    public class SharedObjectExample extends Sprite {
        
        var hostName = "yourDomain";
		var username = "yourUsername";
		var cover_path = "1.png";
		function SharedObjectExample()
		{
			SharedObject_flush();
		}
		function SharedObject_flush() {
			var mySo = SharedObject.getLocal(hostName);
			trace(mySo.data.cover_path);
			trace(mySo.data.username); // yourUsername
			
			mySo.data.username = username;
			mySo.data.cover_path = cover_path;
			var flushResult = mySo.flush();
			
			trace("flushResult: " + flushResult);
			trace(mySo.data.username); // yourUsername
			trace(mySo.data.cover_path);
		}
    }
}
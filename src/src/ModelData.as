package  {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	public class ModelData extends EventDispatcher{
		var myRequest:URLRequest;

		public var loadedData:Array = [];
		var myLoader = new URLLoader  ;
		public function ModelData(path:String) {
			// constructor code
			myRequest = new URLRequest(path);
			myLoader.addEventListener(Event.COMPLETE,onload);
			myLoader.load(myRequest);

		}
		function onload(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE,onload);

			loadedData = myLoader.data.split(/\r\n|\n|\r,/);
			loadedData.pop();
			for (var i:int = 0; i < loadedData.length; i++)
			{
				var rowArray:Array = loadedData[i].split(",");
				loadedData[i] = {CLOTH:new SmoothingBitmapLoader(rowArray[0]),SHADOW:new SmoothingBitmapLoader(rowArray[1])};
				
			}
			loadedData.shift();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}

	}
	
}

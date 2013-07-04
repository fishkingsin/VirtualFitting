package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.desktop.NativeApplication;
	import com.yuco.utils.LoadConfig;
	import net.hires.debug.Logger;
	
	public class BaseApp extends MovieClip
	{

		protected var mXML:XML;
		protected var xmlLoader:URLLoader;

		protected static const PLAYING_SCREEN_SAVER:String = "PLAYING_SCREEN_SAVER";
		protected static const PLAYING_INTRO:String = "PLAYING_INTRO";
		protected static const PLAYING_PREVIEW:String = "PLAYING_PREVIEW";
		protected static const PLAYING_CONTENT:String = "PLAYING_CONTENT";


		protected static var STATE:String = PLAYING_SCREEN_SAVER;


		protected var config:LoadConfig;
		

		public function BaseApp()
		{
			
			
			config = new LoadConfig(stage,"data/config.xml");
			config.addEventListener(Event.COMPLETE,configureComplete);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown);
			addEventListener(MouseEvent.CLICK, btnPressed);
			
			initXML();


		}
		
		//=====================================================================================================================================;
		function configureComplete(e:Event):void
		{
			
			
		}

		//=====================================================================================================================================;
		public function initXML():void
		{
			
			//xml = new XML  ;
			var XML_URL:String = "data/config.xml";

			var myXMLURL:URLRequest = new URLRequest(XML_URL);
			xmlLoader = new URLLoader(myXMLURL);
			xmlLoader.addEventListener(Event.COMPLETE,xmlLoaded,false, 0.0, true);
				

		}
		public function xmlLoaded(event:Event):void
		{
			//trace(event.target.data);
			
		}
		//=====================================================================================================================================;
		protected function btnPressed(e:MouseEvent):void
		{
			mousePressed(e.localX,e.localY);
			trace(e.target.name);
		}
		private function keyPressedDown(event:KeyboardEvent):void
		{
			
			var key:uint = event.keyCode;
			keyPressed(key);
			Logger.debug(key);
			switch (key)
			{
				
				case 27 :
					if(mXML.DEBUG==true)NativeApplication.nativeApplication.exit();
					
					break;
				
				
			}
		}
		protected  function keyPressed(key:int):void
		{
			
		}
		protected 	 function mousePressed( x:int , y:int):void
		{
			
		}

		

	}

}
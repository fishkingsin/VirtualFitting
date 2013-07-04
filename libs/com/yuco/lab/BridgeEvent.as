package com.yuco.lab
{
	import flash.events.Event;
	
	public class BridgeEvent extends Event
	{
		public static const BRIDGE_STATUS:String = "bridge_status";
		public static const CONNECT:String = "connect";
		public static const CLOSE:String = "close";
		public static const ERROR:String = "error";
		
		
		protected var _text:String;
		public function get text():String { return _text; }
		
		public function BridgeEvent(type:String, text:String = "")
		{
			super(type);
			_text = text;
		}
		
		public override function toString():String
		{
			return "com.yuco.lab.BridgeEvent";
		}
	}
}
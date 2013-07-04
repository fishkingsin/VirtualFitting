package com.yuco.lab
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	public class BridgeDataEvent extends Event
	{
		public static const BRIDGE_DATA:String = "bridge_data";

		protected var _boolarray:Array;

		public function get boolarray():Array { return _boolarray; }

		public function BridgeDataEvent(type:String, array:Array) 
		{
			super(type);
			_boolarray = array;
		}
		
	}
}
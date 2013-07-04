package newcommerce.media
{
	import flash.events.Event;
	
	public class MediaCuePointEvent extends Event{
		public static const  CUE_POINT:String = "cue_point";
		protected var _name:String;
		public function set name(name:String):void { _name = name; }
		public function get name():String { return _name; }
		public function MediaCuePointEvent(type:String,name:String) {
			// constructor code
			super(type);
			_name = name
		}

	}
	
}

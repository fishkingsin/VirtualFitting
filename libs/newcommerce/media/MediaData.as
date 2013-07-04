package newcommerce.media
{
	public class MediaData
	{
		protected var _uri:String;
		protected var _title:String;
		protected var _duration:Number;
		protected var _image:String;
		protected var _width:Number;
		protected var _height:Number;
		protected var _position:Number;
		protected var _percentLoaded:Number;
		
		public function set uri(uri:String):void { _uri = uri; }
		public function get uri():String { return _uri; }
		public function set image(image:String):void { _image = image; }
		public function get image():String { return _image; }
		public function set title(title:String):void { _title = title; }
		public function get title():String { return _title; }
		public function set duration(duration:Number):void { _duration = duration; }
		public function get duration():Number { return _duration; }
		public function get width():Number { return _width; }
		public function set width(value:Number):void { _width = value; }
		public function get height():Number { return _height; }
		public function set height(value:Number):void { _height = value; }
		public function get position():Number { return _position; }		
		public function set position(value:Number):void { _position = value; }		
		public function get percentLoaded():Number { return _percentLoaded; }		
		public function set percentLoaded(value:Number):void { _percentLoaded = value; }
		
		function MediaData(uri:String = "", title:String = "", duration:Number = 120,  image:String = "", width:Number = 320, height:Number = 200, position:Number = 0)
		{	
			_position = position;
			_uri = uri;
			_title = title;
			_duration = duration;
			_image = image;
			_width = width;
			_height = height;
		}
	}
}
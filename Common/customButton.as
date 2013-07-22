package {	import flash.text.TextFormat;		import flash.display.Sprite;	import flash.events.Event;	import flash.geom.Point;	public class customButton extends yucoButton	{		private var format1:TextFormat;		private var format2:TextFormat;		//public var buttonBase:yucoButton;		private var _xml:XML;		var sprites1:Array = [];		var sprites2:Array = [];		var next_page:String;		public function customButton(mxml:XML,index:int)		{			_xml = mxml;			this.name = _xml.attribute("name");			//Logger.debug("create button name = " +this.name);			// constructor code;			format1 = CommonProperties.format1;			format2 = CommonProperties.format2;			//var sprites:Array=[];//:Vector.<Sprite> = new Vector.<Sprite>();			for each (var child:XML in _xml.IMAGES[0].FILE)			{				// Logger.debug(child);				var sBmp:BitmapLoader = new BitmapLoader(child);				sBmp.name = this.name;				sprites1.push(sBmp);			}			if (_xml.IMAGES[1])			{				for each (var child:XML in _xml.IMAGES[1].FILE)				{					//Logger.debug(child);					var sBmp:BitmapLoader = new BitmapLoader(child);					sBmp.name = this.name;					sprites2.push(sBmp);				}			}			if (String(_xml.CAPTION.CHIT).length > 0)			{				//Logger.debug("deafult set up chin text");				//Logger.debug("cpation : "+_xml.CAPTION.CHIT);				super.setup((_xml.SHOW_LABLE!=0)?_xml.CAPTION.CHIT:"",_xml.X,_xml.Y,index,sprites1,format1);			}			else			{				//Logger.debug("chi text no found try english");				//Logger.debug("cpation : "+_xml.CAPTION.ENG);				super.setup((_xml.SHOW_LABLE!=0)?_xml.CAPTION.ENG:"",_xml.X,_xml.Y,index,sprites1,format2);			}			next_page = _xml.NEXT_PAGE;			//buttonBase.name = this.name;			//addChild(buttonBase);
			addEventListener(Event.REMOVED_FROM_STAGE ,onRemoved);		}
		private function onRemoved(e:Event)
		{
			removeEventListener(Event.REMOVED_FROM_STAGE ,onRemoved);
			while (sprites1.length>0)
			{
				var s : BitmapLoader = sprites1.pop();
				s.remove();
				s = null;
			}
			while (sprites2.length>0)
			{
				var s : BitmapLoader = sprites2.pop();
				s.remove();
				s = null;
			}
			format1 = null;;
			format2 = null;
			
			//remove();
		}		//function highlight(b:Boolean):void		//{		//	if(b)		//	{		//		super.changeSprite(sprites2);		//	}		//	else		//	{		//		super.changeSprite(sprites1);		//	}		//}		//function changeString():void		//{		//	if (CommonProperties.LANGUAGE == CommonProperties.CHINESE_T)		//	{		//		//buttonBase.changeSprite(sprites1);		//		if (String(_xml.CAPTION.CHIT).length > 0)		//		{		//			super.changeText((_xml.SHOW_LABLE!=0)?_xml.CAPTION.CHIT:"",format1);		//		}		//		if (sprites1.length > 0)		//		{		//			super.changeSprite(sprites1);		//		}		//	}		//	else if (CommonProperties.LANGUAGE==CommonProperties.ENGLISH)		//	{		//		//buttonBase.changeSprite(sprites2);		//		if (String(_xml.CAPTION.ENG).length > 0)		//		{		//			super.changeText((_xml.SHOW_LABLE!=0)?_xml.CAPTION.ENG:"",format2);		//		}		//		if (sprites2.length > 0)		//		{		//			super.changeSprite(sprites2);		//		}		//	}		//}		function get caption():String		{			if (CommonProperties.LANGUAGE == CommonProperties.CHINESE_T)			{				return _xml.CAPTION.CHIT;			}			else if (CommonProperties.LANGUAGE==CommonProperties.ENGLISH)			{				return _xml.CAPTION.ENG;			}			return _xml.CAPTION.CHIT;		}		function get path():String		{			if (CommonProperties.LANGUAGE == CommonProperties.CHINESE_T)			{				return String(_xml.FILES.CHIT);			}			else if (CommonProperties.LANGUAGE==CommonProperties.ENGLISH)			{				return String(_xml.FILES.ENG);			}			return String(_xml.FILES.CHIT);		}		function get nextPage():String		{			return next_page;		}		function get xml():XML		{			return _xml;		}	}}
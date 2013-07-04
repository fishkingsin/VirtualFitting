package  {
		import gs.TweenMax;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class customBackground  extends yucoButton{
		private var xml:XML;
		var sprites1:Array=[];
		var sprites2:Array=[];
		
		public function customBackground(mxml:XML,index:int) {
			mouseEnabled = false;
			xml = mxml;
			this.name = xml.attribute("name");
			trace("create button name = " +this.name);
			
			for each(var child:XML in xml.IMAGES[0].FILE)
				{
					
					var sBmp:SmoothingBitmapLoader = new SmoothingBitmapLoader(child);
					sBmp.name = this.name;
					sprites1.push(sBmp);
				}
			super.setup("",xml.X,xml.Y,index,sprites1,format2);
		}
		function changeString():void{
			if(CommonProperties.LANGUAGE==CommonProperties.CHINESE_T)
			{
				
						super.changeSprite(sprites1);
					
				
			}
			else if(CommonProperties.LANGUAGE==CommonProperties.ENGLISH){
				
						super.changeSprite(sprites2);
					
		}
		function get caption():String{
			if(CommonProperties.LANGUAGE==CommonProperties.CHINESE_T)return xml.CAPTION.CHIT;
			
			else if(CommonProperties.LANGUAGE==CommonProperties.ENGLISH)return xml.CAPTION.ENG;
			return xml.CAPTION.CHIT;
		}
		function get path():String{
			if(CommonProperties.LANGUAGE==CommonProperties.CHINESE_T)return String(xml.FILES.CHIT);
			
			else if(CommonProperties.LANGUAGE==CommonProperties.ENGLISH)return String(xml.FILES.ENG);
			return String(xml.FILES.CHIT);
		}

	}
	
}

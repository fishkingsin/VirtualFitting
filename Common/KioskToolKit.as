package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class KioskToolKit extends BaseApp {
		
		var mInterfacePraser:InterfacePraser;
		public function KioskToolKit() {
			// constructor code
			mInterfacePraser = new InterfacePraser();
			mInterfacePraser.addEventListener(InterfacePraser.INIT,function onComplete(e:Event)
											  {
												  addChild(mInterfacePraser.getPageAt(0));
											  });
		}
	}
	
}

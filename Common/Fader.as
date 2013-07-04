package  {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import com.greensock.TweenMax;
	
	import net.hires.debug.Logger;
	//import com.visualcondition.twease.*;
	public class Fader extends Bitmap{
		var _stage:Sprite;
		//private var _obj_fadeOut:Object;
		//private var _obj_fadeIn:Object;
		var isCopy:Boolean=false;
		public function Fader(stage_:Sprite , _bitmapData:BitmapData) {

			super(_bitmapData);
			smoothing =true;
			_stage = stage_;
			
			this.alpha = 0;
			var e_ob:String = 'easeOutBounce';
			var e_oe:String = 'easeOutElastic';
			var e_l:String = 'linear';
			
			// constructor code
			/*Twease.stacking = false;

			// this is needed if you want to use easing type other than linear, 
			// which is most of the case we do
			Twease.register (Easing);
			//==============================================
			// create an action object to tween
			//==============================================
			_obj_fadeOut = ({target:this, alpha:0.0,time:1, ease:e_l, func:afterFadeOut});

			//==============================================
			// create an action object to tween
			//==============================================
			_obj_fadeIn = ({target:this, alpha:1,time:0, ease:e_l ,func:afterFadeIn});//var*/
		}
		private function afterFadeIn (to,po,q):void
		{
			trace("after fade in");
		}
		private function afterFadeOut ():void
		//private function afterFadeOut (to,po,q):void
		{
			trace("after fade out");
			try{
			if(_stage!=null)_stage.removeChild(this);
			}
			catch(error:Error)
			{
				Logger.debug("Fader: "+error.message);
			}
		}
		public function draw(mc:Sprite,dt:Number=1):void
		{
			this.alpha = 1;
			super.bitmapData.draw(mc);
//			while(_stage.numChildren>0)
//			{
//				_stage.removeChildAt(_stage.numChildren-1);
//			}
			if(_stage!=null)_stage.addChild(this);
			this.x = mc.x;
			this.y = mc.y;
			TweenMax.to(this,dt,{alpha:0,ease:Linear.easeOut,onComplete:afterFadeOut});
			//Twease.tween ( _obj_fadeOut );
		}
		public function copy(mc:Sprite):void
		{
			isCopy = true;
			this.alpha = 1;
			super.bitmapData.draw(mc);

			if(_stage!=null)_stage.addChild(this);
			this.x = mc.x;
			this.y = mc.y;
		}
		public function startFade(dt:Number=1):void{
			if(isCopy)
			{
			TweenMax.to(this,dt,{alpha:0,ease:Linear.easeOut,onComplete:afterFadeOut});
			isCopy = false;
			}
		}


	}
	
}

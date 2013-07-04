﻿package {	import flash.display.Sprite;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.MouseEvent;	import flash.events.KeyboardEvent;	import flash.utils.setInterval;	import flash.utils.clearInterval;	import net.hires.debug.Logger;	import flash.display.Stage;	public class ScreenSaver extends EventDispatcher	{		var interval:int = 0;		var mms:int = 30000;		var fn:String;		var _stage_;Stage;		var _mc_:Sprite;		var bPlaying:Boolean = false;		var enabled:Boolean = true;				public function ScreenSaver(_stage:Stage,seconds:uint)		{			// constructor code			setTimeout(seconds);			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);			_stage.addEventListener(MouseEvent.CLICK,onMouseDown);			onIdel();		}		public function start()		{			resetTimeOut();			enabled = true;		}		public function stop()		{			enabled = false;		}		public function setTimeout(seconds:int)		{			if(seconds>0)mms = seconds*1000;			resetTimeOut();			}		private function onKeyDown(event:KeyboardEvent):void		{			resetTimeOut();			}		private function onMouseDown(e:MouseEvent):void		{			 resetTimeOut();			}		function onIdel():void		{			if(enabled)			{			clearInterval(interval);			interval = setInterval(onIdel,mms);			this.dispatchEvent(new Event("idel"));							//trace("onIdel");			bPlaying = true;			}			//trace("onIdel disable");		}		function resetTimeOut()		{			//trace("ss resetTimeOut()");			clearInterval(interval);			interval = setInterval(onIdel,mms);				this.dispatchEvent(new Event("reset_idel"));					bPlaying = false;		}	}}
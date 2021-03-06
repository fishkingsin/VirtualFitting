﻿package {	import flash.display.Sprite;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.MovieClip;	import flash.display.Loader;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.EventDispatcher;	import flash.net.LocalConnection;	import flash.net.URLRequest;	import net.hires.debug.Logger;	import com.yuco.log.YucoLogger;	public class BitmapLoader extends Sprite	{		public static const INIT = "initLoad";		private var imgbase;		public var imgLoader;		private var _url:String;		private var _loaderContent:Object;		public function get loaderContent():Object{			return _loaderContent;		}		public function BitmapLoader(url)		{			imgbase = new Sprite();			imgLoader = new Loader();			_url = url;			addChild(imgbase);			loadImage(_url);						addEventListener(Event.REMOVED_FROM_STAGE ,onRemoved);		}		public function reloadImage()		{			loadImage(_url);		}		private function onRemoved(e:Event)		{
			trace("SmoothingBitmapLoader onRemoved() : "+name);
			removeEventListener(Event.REMOVED_FROM_STAGE ,onRemoved);
			//remove();		}		public function remove()		{
			trace("SmoothingBitmapLoader remove() : "+name);
			try{
			if ( _url.search(".png")>0 || _url.search(".jpg")>0)
				{

					var bmp:Bitmap = Bitmap(imgLoader.content);
					bmp.bitmapData.dispose();

				}
			}
			catch(e:*)
			{
				trace(e.toString());
			}
			try
			{			while(imgbase.numChildren>0)				{					imgbase.removeChildAt(imgbase.numChildren-1);				}				try {					new LocalConnection().connect('foo');					new LocalConnection().connect('foo');				} catch (e:*){					//Logger.debug("Forcing Garbage Collection :"+e.toString());				}
			}
			catch(e:*)
			{
				trace(e.toString());
			}		}		private function loadImage(url)		{			try			{				while(imgbase.numChildren>0)				{					imgbase.removeChildAt(imgbase.numChildren-1);				}				try {					new LocalConnection().connect('foo');					new LocalConnection().connect('foo');				} catch (e:*){					//Logger.debug("Forcing Garbage Collection :"+e.toString());				}				imgLoader.load(new URLRequest(url));				//trace(url);				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);				imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErroreHandler);							}			catch (err:Error)			{				Logger.debug("Error: Loading:",url);				//trace(err.message);			}		}		private function onErroreHandler(e:IOErrorEvent)		{			trace(e.text);			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));			Logger.error("onErroreHandler",this,e.text);		}		private function onCompleteHandler(e:Event)		{			try			{				_loaderContent = imgLoader.content;				imgbase.addChild(imgLoader);				var str:String = new String(_url);				if (_url.search(".swf") > 0)				{					//trace(_url);				}				else if ( _url.search(".png")>0 || _url.search(".jpg")>0)				{					var bmp = Bitmap(imgLoader.content);					bmp.smoothing = true;				}				dispatchEvent(new Event(INIT));			}			catch (err:Error)			{				trace(err.message);			}		}	}}
﻿package {	//import flash.text.*;	import flash.display.Sprite;	import flash.events.Event;	import flash.geom.Point;	public class customBackground extends Sprite//yucoButton	{		private var xml:XML;		private var sprites1:Array = [];		private var sprites2:Array = [];		public var inPt:Point;		public var outPt:Point;		public function customBackground(mxml:XML,index:int)		{			mouseEnabled = false;			xml = mxml;			this.name = xml.IMAGES.FILE;//xml.attribute("name");						//trace("create button name = " +this.name);			var i:int = 0;						addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);								}		private function onAddedToStage(e:Event)		{			init();						removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);			addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);					}		private function init()		{			var bmp =new  SmoothingBitmapLoader(String(xml.IMAGES.FILE));			bmp.addEventListener(SmoothingBitmapLoader.INIT,function onComplete(e:Event):void			{											addChild(bmp);			bmp.x = xml.X;			bmp.y = xml.Y;			dispatchEvent(new Event(Event.COMPLETE));			});		}		private function onRemovedFromStage(e:Event)		{			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);			removeEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);			while(numChildren>0)			{				removeChildAt(0);			}		}		public function changeString()		{					}	}}
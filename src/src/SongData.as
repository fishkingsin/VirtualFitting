﻿package {	import flash.events.Event;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.events.EventDispatcher;	public class SongData extends EventDispatcher	{		var myRequest:URLRequest;		public var loadedData:Array = [];		var myLoader = new URLLoader  ;		public function SongData(path:String)		{			//trace("SongData loading " +path);			// constructor code			myRequest = new URLRequest(path);			myLoader.addEventListener(Event.COMPLETE,onload);			myLoader.load(myRequest);		}		function onload(e:Event):void		{			e.target.removeEventListener(Event.COMPLETE,onload);			loadedData = myLoader.data.split(/\r\n|\n|\r,/);			/*for (var i:int=0; i<loadedData.length; i++){			loadedData[i] = loadedData[i].split(",");			}*/			loadedData.pop();			for (var i:int = 0; i < loadedData.length; i++)			{				var rowArray:Array = loadedData[i].split(",");				loadedData[i] = {ARTIST:rowArray[0],SONG_NAME:rowArray[1],FILE:rowArray[2],COVER:rowArray[3]};			}			loadedData.shift();			/*for (var i:int = 0; i < loadedData.length; i++)			{				trace(loadedData[i].ARTIST + " " + loadedData[i].SONG_NAME + " " + loadedData[i].FILE + " " + loadedData[i].COVER);			}*/			dispatchEvent(new Event(Event.COMPLETE));		}	}}
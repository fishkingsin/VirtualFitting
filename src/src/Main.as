﻿package {	import flash.events.Event;	import flash.events.MouseEvent;	import flash.display.MovieClip;	import flash.display.Sprite;	import net.hires.debug.Logger;	import gs.TweenMax;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundTransform;	import flash.net.URLRequest;	import flash.net.LocalConnection;	public class Main extends BaseApp	{		private var functionName = "";		var pages:MovieClip = new MovieClip();		var prevPage;		var minterface;		var snd:Sound;//= new Sound  ;		var snd2:Sound;//= new Sound  ;		var sc:SoundChannel;//= new SoundChannel  ;		var st:SoundTransform;//= new SoundTransform  ;	var screenLock:Boolean = false;		public function Main()		{			super();			snd = new Sound  ;			snd2 = new Sound  ;			sc = new SoundChannel  ;			st = new SoundTransform  ;			snd.load(new URLRequest("./data/b1.mp3"));			snd2.load(new URLRequest("./data/b4.mp3"));		}		override public function xmlLoaded(event:Event):void		{			this.mXML = XML(xmlLoader.data);			trace(mXML);			minterface = new InterfacePraser ();			pages.name = "p0";			minterface.addEventListener(InterfacePraser.INIT,function insertToPage(e:Event):void			{			pages.addChild(minterface.getPageAt(0));			prevPage = minterface.getPageAt(0);			});			addChild(pages);			pages.addEventListener(MouseEvent.CLICK, btnPressed);						addEventListener(SongListEvent.SONG_LIST,onSongList);				}		function onSongList(e:SongListEvent)		{			trace("onSongList ",e.data);		}		override protected function btnPressed(e:MouseEvent):void		{			Logger.debug("btnPressed " + e.target.name);
			if(!screenLock)
			{			switch (e.target.name)			{				case "solution_button_confirm":										break;				default :					if (e.target.name.search("btn") >= 0 )					{
						screenLock = true;						var pressedButton = e.target as customButton;						var currentPageSprite = minterface.getPageByName(pressedButton.nextPage);												currentPageSprite.alpha = 0;												pages.addChild(currentPageSprite);						TweenMax.to(currentPageSprite,0.5,{alpha:1 });						TweenMax.to(prevPage,0.5,{alpha:0,onComplete:onCompleteFunction ,onCompleteParams:[pages, currentPageSprite]});						playbackFX(snd);					}					return;					break;			}		}		}		function onCompleteFunction(_parent:Sprite, nextPage:Sprite):void		{			for (var i = 0; i< _parent.numChildren; i++)			{				var mc = _parent.getChildAt(i);				trace("MC name : "+mc.name);				if (mc.name != nextPage.name)				{					_parent.removeChild(mc);				}
			}			/*for each( var mc in _parent)			{			trace("MC name : "+mc.name);			if(mc != nextPage)			{			_parent.removeChild(mc);			}			}*/			prevPage = nextPage;			try			{				new LocalConnection().connect('foo');				new LocalConnection().connect('foo');			}			catch (e: * )			{				trace("Forcing Garbage Collection :"+e.toString());			}
			screenLock=false;		}		function playbackFX(_snd: * ):void		{			try			{				if (_snd!=null && _snd is Sound)				{					var sound:Sound = _snd as Sound;					sc = sound.play();					st.volume = 0.5;					sc.soundTransform = st;				}			}			catch (e:Error)			{			}		}	}}
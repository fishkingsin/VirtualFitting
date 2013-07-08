package {	import flash.events.Event;	import flash.events.MouseEvent;	import flash.display.MovieClip;	import flash.display.Sprite;	import net.hires.debug.Logger;	import gs.TweenMax;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundTransform;	import flash.net.URLRequest;	import flash.net.LocalConnection;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.yuco.utils.LoadConfig;	public class Main extends BaseApp	{
		var delay:uint = 1000*10*60;
		var repeat:uint = 1;		private var functionName = "";		var pages:MovieClip = new MovieClip();		var prevPage;		var minterface;		var snd:Sound;//= new Sound  ;		var snd2:Sound;//= new Sound  ;		var sc:SoundChannel;//= new SoundChannel  ;		var st:SoundTransform;//= new SoundTransform  ;		var screenLock:Boolean = false;
		var Timer1:Timer;
				public function Main()		{			super();			snd = new Sound  ;			snd2 = new Sound  ;			sc = new SoundChannel  ;			st = new SoundTransform  ;			snd.load(new URLRequest("./data/b1.mp3"));			snd2.load(new URLRequest("./data/b4.mp3"));
			
					}		override public function xmlLoaded(event:Event):void		{			this.mXML = XML(xmlLoader.data);			Logger.debug(mXML);			minterface = new InterfacePraser ();			pages.name = "p0";			minterface.addEventListener(InterfacePraser.INIT,function insertToPage(e:Event):void			{			pages.addChild(minterface.getPageAt(0));			prevPage = minterface.getPageAt(0);			});			addChild(pages);			pages.addEventListener(MouseEvent.CLICK, btnPressed);						addEventListener(SongListEvent.SONG_LIST,onSongList);
			
			
			delay = 1000;
			trace(mXML.IDLE);
			
			repeat = mXML.IDLE;
			Timer1 = new Timer(delay, repeat);
			Timer1.start();
			
			Timer1.addEventListener(TimerEvent.TIMER, timerHandler);
			Timer1.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			
			config.addEventListener(LoadConfig.CHANGED,function onChanged(e:Event)
			{
				repeat = mXML.IDLE; 
				Timer1.repeatCount = repeat;
			});				}
		private function timerHandler(e:TimerEvent):void{
			var timer:Timer = e.target as Timer ;
			Logger.debug("Counter "+ timer.currentCount);

		}
		private function completeHandler(e:TimerEvent):void {
			var timer:Timer = e.target as Timer ;

			trace("Complete "+ timer.repeatCount);
			Timer1.removeEventListener(TimerEvent.TIMER, timerHandler);
			Timer1.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			
			Timer1 = new Timer(delay, repeat);
			Timer1.addEventListener(TimerEvent.TIMER, timerHandler);
			Timer1.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			for (var i = 0; i< pages.numChildren; i++)
			{
				var mc = pages.getChildAt(i);
				if(mc.name!="index")
				{					
					var currentPageSprite = minterface.getPageByName("index");
					if(currentPageSprite!=null)
					{
						currentPageSprite.alpha = 0;
						
						pages.addChild(currentPageSprite);
						TweenMax.to(currentPageSprite,0.5,{alpha:1 });
						TweenMax.to(prevPage,0.5,{alpha:1,onComplete:onCompleteFunction ,onCompleteParams:[pages, currentPageSprite]});
						playbackFX(snd);
					}
				}
				else
				{
					break;
				}
			}
		}		function onSongList(e:SongListEvent)		{			Logger.debug("onSongList ",e.data);		}		override protected function btnPressed(e:MouseEvent):void		{
			resetTimer();			Logger.debug("btnPressed " + e.target.name);
			if(!screenLock)
			{			switch (e.target.name)			{				case "solution_button_confirm":										break;				default :					if (e.target.name.search("btn") >= 0 )					{
						screenLock = true;						var pressedButton = e.target as customButton;						var currentPageSprite = minterface.getPageByName(pressedButton.nextPage);						if(currentPageSprite!=null)
						{
							
														currentPageSprite.alpha = 0;														pages.addChild(currentPageSprite);							TweenMax.to(currentPageSprite,0.5,{alpha:1 });							TweenMax.to(prevPage,0.5,{alpha:1,onComplete:onCompleteFunction ,onCompleteParams:[pages, currentPageSprite]});							playbackFX(snd);
						}					}					return;					break;			}		}		}		function onCompleteFunction(_parent:Sprite, nextPage:Sprite):void		{			for (var i = 0; i< _parent.numChildren; i++)			{				var mc = _parent.getChildAt(i);				Logger.debug("MC name : "+mc.name);				if (mc.name != nextPage.name)				{					_parent.removeChild(mc);				}
			}			/*for each( var mc in _parent)			{			Logger.debug("MC name : "+mc.name);			if(mc != nextPage)			{			_parent.removeChild(mc);			}			}*/			prevPage = nextPage;			try			{				new LocalConnection().connect('foo');				new LocalConnection().connect('foo');			}			catch (e: * )			{				Logger.debug("Forcing Garbage Collection :"+e.toString());			}
			screenLock=false;		}		function playbackFX(_snd: * ):void		{			try			{				if (_snd!=null && _snd is Sound)				{					var sound:Sound = _snd as Sound;					sc = sound.play();					st.volume = 0.5;					sc.soundTransform = st;				}			}			catch (e:Error)			{			}		}
		function resetTimer()
		{
			Timer1.reset();
			Timer1.start();
			
		}	}}
package {	import flash.events.Event;	import flash.events.MouseEvent;	import flash.display.MovieClip;	import flash.display.Sprite;	import net.hires.debug.Logger;	import gs.TweenMax;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundTransform;	import flash.net.URLRequest;	import flash.net.LocalConnection;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.filters.BlurFilter;
	import flash.utils.*;
	
	import com.yuco.utils.LoadConfig;
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;	public class Main extends BaseApp	{
		var delay:uint = 1000*10*60;
		var repeat:uint = 1;		private var functionName = "";		var pages:MovieClip = new MovieClip();		var prevPage;		var minterface;		var snd:Sound;//= new Sound  ;		var snd2:Sound;//= new Sound  ;		var sc:SoundChannel;//= new SoundChannel  ;		var st:SoundTransform;//= new SoundTransform  ;		var screenLock:Boolean = false;
		var Timer1:Timer;
		var longPressInterval:uint;
		 var image:ContentDisplay;
		//arc
		var my_canvas:Sprite = new Sprite();
		var deg_to_rad=0.0174532925;
		var charging:Boolean=false;
		var power:int=0;		public function Main()		{			super();			snd = new Sound  ;			snd2 = new Sound  ;			sc = new SoundChannel  ;			st = new SoundTransform  ;			snd.load(new URLRequest("./data/b1.mp3"));			snd2.load(new URLRequest("./data/b4.mp3"));
			
			var blur:BlurFilter = new BlurFilter();
 
			blur.blurX = 5;
			blur.blurY = 5;
			blur.quality = 1;
			var filterArray:Array = new Array(blur);
			my_canvas.filters = filterArray;
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
			});
			/*var myPath:String = "./data/images/"
			var xml1:XML=<BUTTON name="btn_finish">
				<SHOW_LABLE>0</SHOW_LABLE><X>657</X><Y>0</Y>
				<IMAGES>
				<FILE>{myPath+"btn_image_restart.png"}</FILE>
				<FILE>{myPath+"btn_image_restart.png"}</FILE>
				</IMAGES>
				<CAPTION>
				<CHIT>undefined</CHIT>
				</CAPTION>
				<NEXT_PAGE>landing</NEXT_PAGE>
				<MESSAGE>0</MESSAGE>;
				</BUTTON>;
			
				var btn1:customButton = new customButton(xml1,1);
				
				addChild(btn1);*/
			
						//create a LoaderMax named "mainQueue" and set up onProgress, onComplete and onError listeners
			var queue:LoaderMax = new LoaderMax({name:"mainQueue", onProgress:progressHandler, onComplete:completeLoaderHandler, onError:errorHandler});
			 
			//append several loaders
			queue.append( new ImageLoader("./data/images/btn_image_restart.png", {name:"restart", container:this, alpha:1, x:670 , width:50, height:50, scaleMode:"proportionalInside"}) );

			//start loading
			queue.load();		}
		function progressHandler(event:LoaderEvent):void {
			Logger.debug("progress: " + event.target.progress);
		}
		 
		function completeLoaderHandler(event:LoaderEvent):void {
			image = LoaderMax.getContent("restart");
			image.addEventListener(MouseEvent.MOUSE_DOWN,onPressed);
			
			setChildIndex(image,numChildren-1);
			Logger.debug(event.target + " is complete!");
		}
		function onPressed(e:MouseEvent)
		{
			addEventListener(Event.ENTER_FRAME,on_enter_frame);
			trace("onPressed");
			e.target.addEventListener(MouseEvent.MOUSE_UP,onReleased);
			longPressInterval = setInterval(onLongPressed,5000);
			addChild(my_canvas);
						
			my_canvas.x = image.x;
			my_canvas.y = image.y;
		}
		function onReleased(e:MouseEvent)
		{
			removeEventListener(Event.ENTER_FRAME,on_enter_frame);
			trace("onReleased");
			e.target.removeEventListener(MouseEvent.MOUSE_UP,onReleased);
			clearInterval(longPressInterval);
			removeChild(my_canvas);
			power = 0;
		}
		function onLongPressed()
		{
			removeEventListener(Event.ENTER_FRAME,on_enter_frame);
			removeChild(my_canvas);
			trace("onLongPressed");
			image.removeEventListener(MouseEvent.MOUSE_UP,onReleased);
			clearInterval(longPressInterval);
			gotoLandingPage();
			power = 0;
		}
		  
		function errorHandler(event:LoaderEvent):void {
			Logger.debug("error occured with " + event.target + ": " + event.text);
		}
		private function timerHandler(e:TimerEvent):void{
			//var timer:Timer = e.target as Timer ;
			//Logger.debug("Counter "+ timer.currentCount);
			try
			{
				new LocalConnection().connect('foo');
				new LocalConnection().connect('foo');
			}
			catch (e: * )
			{
				Logger.debug("Forcing Garbage Collection :"+e.toString());
			}

		}
		private function completeHandler(e:TimerEvent):void {
			var timer:Timer = e.target as Timer ;

			trace("Complete "+ timer.repeatCount);
			Timer1.removeEventListener(TimerEvent.TIMER, timerHandler);
			Timer1.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			
			Timer1 = new Timer(delay, repeat);
			Timer1.addEventListener(TimerEvent.TIMER, timerHandler);
			Timer1.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			gotoLandingPage();
		}
		function gotoLandingPage()
		{
			for (var i = 0; i< pages.numChildren; i++)
			{
				var mc = pages.getChildAt(i);
				if(mc.name!="landing")
				{					
					var currentPageSprite = minterface.getPageByName("landing");
					if(currentPageSprite!=null)
					{
						currentPageSprite.alpha = 0;
						
						pages.addChild(currentPageSprite);
						TweenMax.to(currentPageSprite,0.5,{delay:1,alpha:1 });
						TweenMax.to(prevPage,0.5,{alpha:1,delay:1,onComplete:onCompleteFunction ,onCompleteParams:[pages, currentPageSprite]});
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
							
														currentPageSprite.alpha = 0;														pages.addChild(currentPageSprite);							TweenMax.to(currentPageSprite,0.5,{delay:1,alpha:1 });							TweenMax.to(prevPage,0.5,{delay:1,alpha:1,onComplete:onCompleteFunction ,onCompleteParams:[pages, currentPageSprite]});							playbackFX(snd);
						}					}					return;					break;			}		}		}		function onCompleteFunction(_parent:Sprite, nextPage:Sprite):void		{			for (var i = 0; i< _parent.numChildren; i++)			{				var mc = _parent.getChildAt(i);				Logger.debug("MC name : "+mc.name);				if (mc.name != nextPage.name)				{					_parent.removeChild(mc);				}
			}			/*for each( var mc in _parent)			{			Logger.debug("MC name : "+mc.name);			if(mc != nextPage)			{			_parent.removeChild(mc);			}			}*/			prevPage = nextPage;			try			{				new LocalConnection().connect('foo');				new LocalConnection().connect('foo');			}			catch (e: * )			{				Logger.debug("Forcing Garbage Collection :"+e.toString());			}
			screenLock=false;		}		function playbackFX(_snd: * ):void		{			try			{				if (_snd!=null && _snd is Sound)				{					var sound:Sound = _snd as Sound;					sc = sound.play();					st.volume = 0.5;					sc.soundTransform = st;				}			}			catch (e:Error)			{			}		}
		function resetTimer()
		{
			Timer1.reset();
			Timer1.start();
			
		}
		public function on_enter_frame(e:Event) {
			
				power+=1;
				
				if (power>=150) {
					charging=false;
					my_canvas.graphics.clear();
					power=0;
				}
				my_canvas.graphics.clear();
				my_canvas.graphics.lineStyle(5,0xFFFFFF,1, false, "normal","Square","Square" );
				draw_arc(my_canvas,25,25,25,270,270+power*2.4,1);
			
		}
		public function draw_arc(movieclip,center_x,center_y,radius,angle_from,angle_to,precision) {
			var angle_diff=angle_to-angle_from;
			var steps=Math.round(angle_diff*precision);
			var angle=angle_from;
			var px=center_x+radius*Math.cos(angle*deg_to_rad);
			var py=center_y+radius*Math.sin(angle*deg_to_rad);
			movieclip.graphics.moveTo(px,py);
			for (var i:int=1; i<=steps; i++) {
				angle=angle_from+angle_diff/steps*i;
				movieclip.graphics.lineTo(center_x+radius*Math.cos(angle*deg_to_rad),center_y+radius*Math.sin(angle*deg_to_rad));
			}
		}	}}
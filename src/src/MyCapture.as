package  {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import gs.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import net.hires.debug.Logger;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import com.adobe.images.PNGEncoder;
	public class MyCapture extends Capture {


		private var delay:uint = 1000;
		private var repeat:uint = 6;
		private var repeat2:uint = 11;
		private var numSnap:uint = 5;
		private var Timer1:Timer = new Timer(delay, repeat);
		private var Timer2:Timer = new Timer(delay, repeat2);
		var snd:Sound;//= new Sound  ;
		var sc:SoundChannel;//= new SoundChannel  ;
		var st:SoundTransform;//= new SoundTransform  ;
		
		
		var shutterSound:Sound;//= new Sound  ;
		var shutterSoundChannel:SoundChannel;//= new SoundChannel  ;
		var shutterSoundTransform:SoundTransform;//= new SoundTransform  ;
		
		var counterSound:Sound;//= new Sound  ;
		var counterSoundChannel:SoundChannel;//= new SoundChannel  ;
		var counterSoundTransform:SoundTransform;//= new SoundTransform  ;
		
		var savedBitmap:Array = new Array();
		var counter1:SmoothingBitmapLoader;
		var counter2:SmoothingBitmapLoader;
		var blink:SmoothingBitmapLoader;
		private static const modelPath:String = "./data/images/model/";
		private static const myPath:String = "./data/images/";
		private static const TAG:String = "gamecore";
		
		private static const SCALE:Number = 10;
		private static const MIDX:Number = 360;
		private static const MIDY:Number = 640;
		var index:uint = 0 ;
		var shadow:MovieClip = new MovieClip();
		var modelData:ModelData;
		var ranNumbers:Array;
		var fishBMP:SmoothingBitmapLoader = new SmoothingBitmapLoader("./selectcover.swf");
		
		public function MyCapture() {
			// constructor code
			super();
			counterSound = new Sound(new URLRequest("./data/Morse.mp3"));
			counterSoundChannel = new SoundChannel  ;
			counterSoundTransform = new SoundTransform  ;
		}
		override protected function init()
		{
			super.init();
			Start();
			blink = new SmoothingBitmapLoader("./flashing.swf");
			/*blink.graphics.beginFill(0xFFFFFF,1.0);
			blink.graphics.drawRect(0,0,720,1280);
			blink.graphics.endFill();*/
			
			Logger.debug(TAG,MySharedObjectConstant.getCategory());
			if(MySharedObjectConstant.getCategory()!=null)
			{
			
				modelData= new ModelData(getRootPath()+modelPath+MySharedObjectConstant.getCategory());
			}
			else
			{
				MySharedObjectConstant.setCategory("POP");
				modelData= new ModelData(getRootPath()+modelPath+MySharedObjectConstant.getCategory());
			}
			modelData.addEventListener(Event.COMPLETE,function onDataLoaded(e:Event)
			{
				modelData.removeEventListener(Event.COMPLETE, onDataLoaded);
				
				ranNumbers = [ uint (randomNumber(0,modelData.loadedData.length-1))];//
				/*,
					uint (randomNumber(0,modelData.loadedData.length)),
					uint (randomNumber(0,modelData.loadedData.length)),
					uint (randomNumber(0,modelData.loadedData.length)),
					uint (randomNumber(0,modelData.loadedData.length))];*/
				//Logger.debug(ranNumbers);
				var newRand:uint = uint (randomNumber(0,modelData.loadedData.length-1));
				while(ranNumbers.length<5)
				{
					var ret:Boolean = false;
					for (var i:uint = 0 ;  i<ranNumbers.length ;i++)
					{
						if(ranNumbers[i]==newRand)
						{
							newRand = uint (randomNumber(0,modelData.loadedData.length-1));
							ret = false;
							break;
						}
						else
						{
							ret = true;
						}
					}
					if(ret)
					{
						ranNumbers.push(newRand);
					}
				}
				Logger.debug(ranNumbers);
				
				
				counter1 = new SmoothingBitmapLoader(getRootPath()+"./countdown1.swf");
				counter1.addEventListener(SmoothingBitmapLoader.INIT, function onLoaded1(e:Event)
				{
					counter1.removeEventListener(SmoothingBitmapLoader.INIT,onLoaded1);
					addChild(counter1);
					counter2 = new SmoothingBitmapLoader(getRootPath()+"./countdown2.swf");
					counter2.addEventListener(SmoothingBitmapLoader.INIT, function onLoaded2(e:Event)
					{
						counter2.removeEventListener(SmoothingBitmapLoader.INIT, onLoaded2);
						var delayTimer:Timer = new Timer(1500,1);
						delayTimer.start(); 
						
						delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function _completeHandler(e:TimerEvent)
						{
							
							delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _completeHandler);
							delayTimer = null;
							Timer1.start(); 
							
							Timer1.addEventListener(TimerEvent.TIMER, timerHandler);
							Timer1.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
						});
					});
				});
			});
			
			
			
			
			
			
			


		}
		override protected function onDraw()
		{
			super.onDraw();
		}
		private function timerHandler(e:TimerEvent):void{
			repeat--;
			counter1.loaderContent.gotoAndStop(counter1.loaderContent.currentFrame+1);
			Logger.debug("Counter "+ repeat);
			if(repeat>0)playMorse();

		}
		private function initSound()
		{
			Logger.debug(TAG+ " initSount" + MySharedObjectConstant.getSongPath());
			var songPath:String;
			if(MySharedObjectConstant.getSongPath()!=null)songPath = MySharedObjectConstant.getSongPath();
			else songPath = "./data/mp3/pop/01.mp3";
			Logger.debug(TAG+ " songPath "+songPath);
			snd = new Sound(new URLRequest(songPath));
			sc = new SoundChannel  ;
			st = new SoundTransform  ;
			
			//snd.load();
			
			sc = snd.play();
			st.volume = 1;
			sc.soundTransform = st;
			
			
			shutterSound = new Sound(new URLRequest("./data/CAMERA.mp3"));
			shutterSoundChannel = new SoundChannel  ;
			shutterSoundTransform = new SoundTransform  ;
			
			
			
		}
		private function playShutter()
		{
			shutterSoundChannel = shutterSound.play();
			shutterSoundTransform.volume = 0.5;
			shutterSoundChannel.soundTransform = shutterSoundTransform;
		}
		private function playMorse()
		{
			counterSoundChannel = counterSound.play();
			counterSoundTransform.volume = 0.5;
			counterSoundChannel.soundTransform = counterSoundTransform;
		}
		override protected function destroy()
		{
			try{
				for (var i:int = 0; i < modelData.loadedData.length; i++)
				{
					
					modelData.loadedData[i].CLOTH.remove();
					modelData.loadedData[i].SHADOW.remove();
					
				}
			}
			catch (e: * )
			{
				trace("modelData destory error:"+e.toString());
			}
			
			try{
				super.destroy();
				Timer1.removeEventListener(TimerEvent.TIMER, timerHandler);
				Timer1.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
				Timer2.removeEventListener(TimerEvent.TIMER, timerHandler2);
				Timer2.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler2);
				while(savedBitmap.length>0)
				{
					
					var bmd:BitmapData = savedBitmap.pop();
					bmd.dispose();
				}
				
				if(snd!=null)
				{
				/*	snd = new Sound  ;
				sc = new SoundChannel  ;
				st = new SoundTransform  ;*/
					TweenMax.to(sc, delay, {volume:0, onComplete:function stopSound()
									{
										
				
										if(sc!=null)sc.stop();
										
									}});
				}
			}catch (e: * )
			{
				Logger.debug("gamecore destory error:"+e.toString());
				trace("gamecore destory error:"+e.toString());
			}
			
			try{
				Logger.debug("gamecord : removeAll Child");
				trace("gamecord : removeAll Child");
				while(numChildren>0)
				{
					removeChildAt(0);
				}
			}catch (e: * )
			{
				trace("gamecore destory error:"+e.toString());
			}
			
			
		}
		private function completeHandler(e:TimerEvent):void {
			initSound();
			Timer1.removeEventListener(TimerEvent.TIMER, timerHandler);
			Timer1.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			Timer1 = null;
			repeat2 = 11;
			repeat = 5;
			Timer2.start(); 
			Timer2.addEventListener(TimerEvent.TIMER, timerHandler2);
			Timer2.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler2);
			addChild(shadow);
			initShadow();
			addChild(counter2);
			removeChild(counter1);
			Logger.debug("completeHandler "+ repeat);
		}
		private function timerHandler2(e:TimerEvent):void{
			repeat2--;
			Logger.debug("Time 2 repeat2 "+ repeat2);
			counter2.loaderContent.gotoAndStop(counter2.loaderContent.currentFrame+1);
			if(repeat2>1 &&  repeat2<7)
			{
				playMorse();
			}
			if(repeat2==1)
			{
				playShutter();

				shadow.removeChildAt(0);
				Pause();
				addChild(blink);
				blink.alpha = 1;
				blink.loaderContent.play();
				super.bitmapData.draw(modelData.loadedData[ ranNumbers[index]].CLOTH);
				
				TweenMax.to(blink,1,{alpha:1,onComplete:function onCompleteFunction()
					{
						removeChild(blink);
					}});
			}
		}

		private function completeHandler2(e:TimerEvent):void {
			
			Logger.debug("Time 2 Complete numSnap " + numSnap);
			Timer2.removeEventListener(TimerEvent.TIMER, timerHandler2);
			Timer2.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler2);
			
			
			repeat2 = 11;
			
			if(numSnap==1)
			{
				Pause();
				saveImage();
				//sc.stop();
				Timer2.removeEventListener(TimerEvent.TIMER, timerHandler2);
				Timer2.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler2);
				Timer2 = null;
				Logger.debug("Time 2 Complete");

				if (vid!=null && cam!=null )
				{
					vid.attachCamera(null);
				}
				
				removeChild(shadow);

				/**/
				
				addEventListener(Event.ENTER_FRAME, function renderHandler(event:Event)
				{
					saveImages();
					addChild(fishBMP);
					
					fishBMP.loaderContent.addEventListener(MySharedObjectConstant.UPLOAD_COMPLETE,function onUploadComplete(e:Event)
						{
							fishBMP.loaderContent.removeEventListener(MySharedObjectConstant.UPLOAD_COMPLETE, onUploadComplete);
							//dispatchEvent(new Event(PostToFacabook.UPLOAD_COMPLETE));
							
	
							TweenMax.to(sc, 1, {volume:0, onComplete:function stopSound()
								{
									if(sc!=null)sc.stop();
								}});
						});
						
					fishBMP.loaderContent.addEventListener(MyEvent.GO_TO_NEXT_PAGE,function onNext(e:Event)
					{
						fishBMP.loaderContent.removeEventListener(MyEvent.GO_TO_NEXT_PAGE, onNext);
						dispatchEvent(new Event(MyEvent.GO_TO_NEXT_PAGE));
						removeChild(fishBMP);
						destroy();
					});

					
					removeEventListener(Event.ENTER_FRAME, renderHandler );
				});
					
					
				
					
					/*
				var xml1:XML=<BUTTON name="btn_finish">
				<SHOW_LABLE>0</SHOW_LABLE><X>300</X><Y>972</Y>
				<IMAGES>
				<FILE>{myPath+"button_confirm.png"}</FILE>
				<FILE>{myPath+"button_confirm.png"}</FILE>
				</IMAGES>
				<CAPTION>
				<CHIT>undefined</CHIT>
				</CAPTION>
				<NEXT_PAGE>selectcover</NEXT_PAGE>
				<MESSAGE>0</MESSAGE>;
				</BUTTON>;
			
				var btn1:customButton = new customButton(xml1,1);
				btn1.addEventListener(MouseEvent.CLICK,function onClick(e:MouseEvent)
									  {
										 dispatchEvent(new Event(MyEvent.GO_TO_NEXT_PAGE)); 
									  });
				addChild(btn1);*/
			}
			else
			{
				
				Timer2 = new Timer(delay, repeat2);
				Timer2.addEventListener(TimerEvent.TIMER, timerHandler2);
				Timer2.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler2);
				Timer2.start(); 
				
				numSnap--;
				saveImage();
				index++;
				if(index<modelData.loadedData.length)
				{
					initShadow();
				}
				
				Start();
			}
			
		}
		override protected function onClick(e:MouseEvent)
		{
			
			
			saveImage();
		}
		function saveImage()
		{
			
			var newBMPD:BitmapData = super.bitmapData.clone();
			savedBitmap.push(newBMPD);
			Logger.debug("push Array  "+savedBitmap.length);
			
		}
		function saveImages()
		{
			//if(savedBitmap.length==5)
			//{
			var now:Date = new Date();
			
			Logger.debug("Start : millis "+String(now.time.valueOf()));
			var paths:Array = new Array();
			while(savedBitmap.length>0)
			{
				Logger.debug("savedBitmap "+savedBitmap.length);
				var bmd:BitmapData = savedBitmap.pop();
				var path:String = captureAndSave(bmd);
				paths.push(path);
				bmd.dispose();
			}
			now = new Date();
			Logger.debug("End : millis "+String(now.time.valueOf()));
			//}
			MySharedObjectConstant.setSavedPhotos(paths);
		}
		
		function randomNumber(min:Number, max:Number):Number {
			//good
			return Math.floor(Math.random() * (1 + max - min) + min);
		}
		function initShadow()
		{
			shadow.addChild(modelData.loadedData[ ranNumbers[index]].SHADOW);
			shadow.scaleX = shadow.scaleY = SCALE;
			shadow.x = -((shadow.width*0.5)-MIDX );
			shadow.y = -((shadow.height*0.5)-MIDY );
			TweenMax.to(shadow,5,{scaleX:1,scaleY:1,x:0,y:0});
		}
	}

}

package newcommerce.media
{
	import newcommerce.media.MediaSizeEvent;
	import newcommerce.media.MediaTimeEvent;
	import newcommerce.media.MediaData;
	import newcommerce.media.MediaEvent;
	
	import flash.media.SoundTransform;
	
	import flash.net.NetConnection;	
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;	
	import flash.events.SecurityErrorEvent;
	import flash.events.AsyncErrorEvent;
	
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.utils.*;
	
	import flash.events.TimerEvent;
	
	public class FLVPlayer extends EventDispatcher
	{	
		/** 
		 * [broadcast event] Dispatcher when a thumb is selected.
		 * @eventType newcommerce.media.MediaEvent.FINISHED_PLAYING
		 */		
		[Event(name="finished_playing",type="newcommerce.media.MediaEvent")]

		/** 
		 * [broadcast event] Dispatcher when a thumb is selected.
		 * @eventType newcommerce.media.MediaEvent.STARTED_PLAYING
		 */		
		[Event(name="started_playing",type="newcommerce.media.MediaEvent")]
		
		/** 
		 * [broadcast event] Dispatcher when a thumb is selected.
		 * @eventType newcommerce.media.MediaTimeEvent.TIME
		 */		
		[Event(name="media_time",type="newcommerce.media.MediaTimeEvent")]
		
		/** 
		 * [broadcast event] Dispatcher when a thumb is selected.
		 * @eventType newcommerce.media.MediaTimeEvent.DURATION
		 */		
		[Event(name="media_duration",type="newcommerce.media.MediaTimeEvent")]
	
		/** 
		 * [broadcast event] Dispatcher when a thumb is selected.
		 * @eventType newcommerce.media.MediaSizeEvent.SIZE
		 */		
		[Event(name="media_size",type="newcommerce.media.MediaSizeEvent")]
		
		/** 
		 * [broadcast event] Dispatcher when a thumb is selected.
		 * @eventType newcommerce.media.MediaEvent.ERROR
		 */		
		[Event(name="error",type="newcommerce.media.MediaEvent")]		
		
		protected var _currentMedia:MediaData;			
		protected var _stream:NetStream;
		protected var _paused:Boolean = false;
		protected var _playing:Boolean = false;
		protected var isLoop:Boolean = false;
		protected var _timer:Timer;		
		protected var _soundTransform:SoundTransform;
		protected var _lastVolume:Number = 1;
		protected var _mute:Boolean = false;		
		protected var _connection:NetConnection;		
		protected var _mediaFinished:Boolean = false;		
		protected var _streamStatus:Array;
		protected var _lastPos:Number;
		protected var _video:Video;
				
		public function set video(video:Video):void { _video = video; }
		public function get video():Video { return _video; }		
		public function get playing():Boolean { return _playing; }		
		public function get paused():Boolean { return _paused; }		
		public function get currentMedia():MediaData { return _currentMedia; }		
		public function get volume():Number { return _lastVolume * 100; } 	
		public function get loop():Boolean { return isLoop; }
		
		
		public function get position():Number 
		{
			if(_stream != null)
				return _stream.time;
			else
				return 0;
		}
		
		public function get duration():Number
		{
			if(_currentMedia != null)
			{
				return _currentMedia.duration;
			}
			else
				return -1;
		}
		
		public function FLVPlayer()
		{			
			_soundTransform = new SoundTransform();

			_timer = new Timer(250);
			_timer.addEventListener(TimerEvent.TIMER, doMediaTime);

			_streamStatus = [];
		}
		
		
		protected function pushStatus(status:String):void
		{
			_streamStatus.push(status);
			while (_streamStatus.length > 3)
				_streamStatus.shift();
		}
		
		public function reset():void
		{
			stop();
			newStream();
		}
		
		protected function newStream():void
		{			
			if(_stream != null)
			{
				_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, doAsyncError);
				_stream.removeEventListener(NetStatusEvent.NET_STATUS, doStreamStatus);
				_stream.removeEventListener(IOErrorEvent.IO_ERROR, doIOError);
				_stream.close();
			}
		
			if(_connection != null)
			{
				_connection.removeEventListener(NetStatusEvent.NET_STATUS, doConnectionStatus);
				_connection.removeEventListener(IOErrorEvent.IO_ERROR, doIOError);
				_connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, doSecurityError);
				_connection.close();
			}
			
			_connection = new NetConnection();
			_connection.connect(null);
			_connection.addEventListener(NetStatusEvent.NET_STATUS, doConnectionStatus);
			_connection.addEventListener(IOErrorEvent.IO_ERROR, doIOError);
			_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, doSecurityError);
			
			_stream = new NetStream(_connection);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, doAsyncError);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, doStreamStatus);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, doIOError);
			_stream.client = this;//new Object();
			
			_video.attachNetStream(_stream);

			_stream.bufferTime = 1;
			_stream.receiveAudio(true);
			_stream.receiveVideo(true);
		}
		public function set loop(b:Boolean):void{isLoop = b;};
		public function stop():void
		{
			if(!_playing)
				return;
				
			_stream.pause();
			_playing = false;
			_timer.stop();
		}
		
		public function playMedia(media:MediaData):void
		{
			_mediaFinished = false;			
			if(media == null)
				return;
			
			_currentMedia = media;
			_streamStatus = [];
			
			play(true);
		}	
		
		public function seek(seconds:Number):void
		{
			if (seconds < _currentMedia.duration-2 && _playing)
			{
				_lastPos = _stream.time;
				_stream.seek(seconds);
				_stream.resume();
			}
		}
		
		public function pause():void
		{			
			_stream.pause();
			_paused = true;
			_timer.stop();		
		}
		var id:Number;
		public function rewind():void{
			//this.pause();
			var dest:Number = _stream.time;
			_stream.seek(dest -= 2);
		}
		protected function doConnectionStatus(evt:NetStatusEvent):void
		{
			//trace("connection: " + evt.info.code);
		}
		
		protected function doStreamStatus(evt:NetStatusEvent):void
		{			
			//trace("stream: " + evt.info.code);
			if (evt.info.code == "NetStream.Seek.InvalidTime")
			{
				_stream.seek(_lastPos);
				_stream.resume();
			}
			else if (evt.info.code == "NetStream.Play.StreamNotFound")
			{
				//error
				dispatchEvent(new MediaEvent(MediaEvent.ERROR,"NetStream.Play.StreamNotFound"));
			}
			else
			{
				pushStatus(evt.info.code);			
				analyzeStatus();
			}
		}
		
		protected function analyzeStatus():void
		{
			//trace("analyzeStatus()");
			var stopIdx:Number = _streamStatus.lastIndexOf("NetStream.Play.Stop");
			var flushIdx:Number = _streamStatus.lastIndexOf("NetStream.Buffer.Flush");
			var emptyIdx:Number = _streamStatus.lastIndexOf("NetStream.Buffer.Empty");
			
			var mediaFinished:Boolean = false;
			
			if (stopIdx > -1 && flushIdx > -1 && emptyIdx > -1)
			{
				if (flushIdx < stopIdx && stopIdx < emptyIdx)
				{
					mediaFinished = true;
					
				}
			}
			else if (flushIdx > -1 && emptyIdx > -1)
			{
				if (flushIdx < emptyIdx)
					mediaFinished = true;
			}
			else if (stopIdx > -1 && flushIdx > -1)
			{
				if(!isLoop)
				{
					
					mediaFinished = true;
				}
				else
				{
					//trace("_stream.seek(0);");
					_stream.seek(0);
				}
				
			}
			
			if (mediaFinished)
			{	
				//trace("finished playing");
				//trace(MediaEvent.FINISHED_PLAYING);
				dispatchEvent(new MediaEvent(MediaEvent.FINISHED_PLAYING));
				
				while (_streamStatus.length > 0)
					_streamStatus.pop();
			}			
			else if (_streamStatus[_streamStatus.length-1] == "NetStream.Play.Start")
				dispatchEvent(new MediaEvent(MediaEvent.STARTED_PLAYING));
			
		}
		
		public function mute(muted:Boolean = true):void
		{
			_mute = muted;
			if(_mute)
			{
				_soundTransform.volume = 0;
				_stream.soundTransform = _soundTransform;
			}
			else
			{
				_soundTransform.volume = _lastVolume;
				_stream.soundTransform = _soundTransform;
			}
		}
		
		public function setVolume(volume:Number):void
		{		
			_lastVolume = _soundTransform.volume = volume/100;
			
			if(!_mute)
				_stream.soundTransform = _soundTransform;						
		}

		public function play(forced:Boolean = false):void
		{
			if(_paused && !forced)
			{
				_stream.resume();
				_paused = false;
				_timer.start();
				return;
			}

			reset();

			_stream.play(_currentMedia.uri);

			setVolume(this._lastVolume*100);

			_playing = true;
			_paused = false;
			_timer.start();
		}
		public function onCuePoint(item:Object):void{
			dispatchEvent(new MediaCuePointEvent(MediaCuePointEvent.CUE_POINT, item.name));
		}
		public function onMetaData(infoObject:Object):void
        {
			if (infoObject.duration != null)
			{
				// dispatch a DURATION event
				dispatchEvent(new MediaTimeEvent(MediaTimeEvent.DURATION, infoObject.duration));
				_currentMedia.duration = infoObject.duration;
			}

			var lclHeight:Number = infoObject.height;
			var lclWidth:Number = infoObject.width;

			if(isNaN(lclHeight) || isNaN(lclWidth))
			{
				lclWidth = 425;
				lclHeight= 320;
			}
			
			_currentMedia.width = lclWidth;
			_currentMedia.height = lclHeight;

			// dispatch the size received event
			dispatchEvent(new MediaSizeEvent(MediaSizeEvent.SIZE, lclWidth, lclHeight));

			if(!willTrigger(MediaSizeEvent.SIZE))
			{
				/*var yDif:Number = (_video.height - lclHeight)/2;
				_video.y -= yDif/2;				
				_video.height = lclHeight;			*/
			}
        }
		
		public function doMediaTime(evt:TimerEvent):void
		{
			var pct:Number = Math.round(_stream.bytesLoaded / _stream.bytesTotal * 100);
			
			_currentMedia.position = _stream.time;
			_currentMedia.percentLoaded = pct;
			
			
			// dispatch a MEDIA_TIME event
			dispatchEvent(new MediaTimeEvent(MediaTimeEvent.TIME, _stream.time, pct));
		}
		
		protected function doSecurityError(evt:SecurityErrorEvent):void
		{
			//trace("AbstractStream.securityError");
			dispatchEvent(new MediaEvent(MediaEvent.ERROR, evt.text));
		}
		
		protected function doIOError(evt:IOErrorEvent):void
		{
			//trace("AbstractScreem.ioError");
			dispatchEvent(new MediaEvent(MediaEvent.ERROR, evt.text));
		}
		
		protected function doAsyncError(evt:AsyncErrorEvent)
		{
			//trace("AsyncError");			
			dispatchEvent(new MediaEvent(MediaEvent.ERROR, evt.text));
		}		
		
		protected function doNetStatus(evt:NetStatusEvent):void
		{
		}		
	}
}
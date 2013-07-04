
package 
{
	import flash.display.Sprite;
	import flash.media.Video;
	import newcommerce.media.FLVPlayer;
	import newcommerce.media.MediaData;
	import newcommerce.media.MediaEvent;
	import newcommerce.media.MediaSizeEvent;
	import newcommerce.media.MediaTimeEvent;
	import flash.events.Event;
	import net.hires.debug.Logger;
/** 
	 * ...
	 * @author Martin Legris
	 */
	public class FLVPlayerClass extends Sprite
	{
		// Video instance to display the video
		protected var _video:Video;

		// player Instance to control the playback
		public var _player:FLVPlayer;
		public var isLoop:Boolean = false;
		private var oldPath:String;

		public function FLVPlayerClass()
		{
			this.width = 1280;
			this.height = 720;
			init();
			createChilds();
			initEvents();
/*addEventListener(Event.ADDED_TO_STAGE,function onAddedToStage(E:Event)
							 {
								startVid(); 
							 });*/

			addEventListener(Event.REMOVED_FROM_STAGE,function onAddedToStage(E:Event)
			 {
			//_player.stop();
			 });



		}

		protected function init():void
		{
			// create the player
			_player = new FLVPlayer();
		}

		protected function createChilds():void
		{
			// create the video
			_video = new Video(this.width,this.height);

			// add to displayList
			addChild(_video);

			// connect the player with the video
			_player.video = _video;
		}
		public function setLoop(b:Boolean)
		{
			isLoop = b;
			_player.loop = isLoop;
		}

		public function stopVid():void
		{
			
			_player.stop();
		}
		public function clear():void
		{
			_video.clear();
		}
		public function startVid(path:String):void
		{


			Logger.debug("start playing video "+path);

			
			// create a mediaData instance, with the URL of the media we want to play
			var media:MediaData = new MediaData(path);
			if (oldPath != path)
			{
				if (! isLoop)
				{
					//_video.clear();
				}
				oldPath = path;
			}
			// play the media..
			_player.playMedia(media);
			_player.seek(0);


		}
		protected function initEvents():void
		{
			_player.addEventListener(MediaSizeEvent.SIZE, doMediaSize);
			_player.addEventListener(MediaEvent.STARTED_PLAYING, doMediaStarted);
			_player.addEventListener(MediaEvent.FINISHED_PLAYING, doMediaFinished);
			_player.addEventListener(MediaEvent.ERROR, doMediaError);
			_player.addEventListener(MediaTimeEvent.DURATION, doMediaDuration);
			_player.addEventListener(MediaTimeEvent.TIME, doMediaTime);
		}
		protected function doMediaSize(evt:MediaSizeEvent):void
		{
			// here we fit the Video object to the exact dimensions of the FLV video
			//_video.width = evt.width;
			//_video.height = evt.height;
		}
		protected function doMediaStarted(evt:MediaEvent):void
		{
			//Logger.debug("FLVPlayerClass: media started playing");
		}

		protected function doMediaFinished(evt:MediaEvent):void
		{
			Logger.debug("FLVPlayerClass: media finished playing");
			if (isLoop)
			{
				
				startVid(oldPath);
			}
		}
		protected function doMediaError(evt:MediaEvent):void
		{
			//Logger.debug("FLVPlayerClass: media error while playing");
		}
		protected function doMediaDuration(evt:MediaTimeEvent):void
		{
			//Logger.debug("FLVPlayerClass: media is " + evt.time + " seconds long");
		}
		protected function doMediaTime(evt:MediaTimeEvent):void
		{
			//Logger.debug("FLVPlayerClass: media is at " + evt.time + " seconds");
		}
	}
}
package  {
	
	import flash.display.MovieClip;
	import com.thanksmister.touchlist.renderers.TouchListItemRenderer;
	import com.thanksmister.touchlist.events.ListItemEvent;
	import com.thanksmister.touchlist.controls.TouchList;
	import flash.events.Event;
	import flash.display.LoaderInfo;
	import net.hires.debug.Logger;
	public class solution extends MovieClip {
		var WIDTH = 720;
		var HEIGHT = 1280;
		var _category:String;
		public function solution() {
			
			
			if (stage)
			{
				createCategoryList();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			}
		}
		function onAdded(e:Event):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			createCategoryList();
		}
		function onRemoved(e:Event):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE,onRemoved);
		
		}

		function createCategoryList()
		{
			var category:SmoothingBitmapLoader = new SmoothingBitmapLoader(getFullPath(loaderInfo) +"category.swf");
			category.addEventListener(SmoothingBitmapLoader.INIT,function onLoaded(e:Event)
			{
			category.removeEventListener(SmoothingBitmapLoader.INIT,onLoaded);
			addChild(category);
				
			category.loaderContent.addEventListener(SongListEvent.SONG_CATEGORY,onCategoryList);
			});
		}
		function createSongList(category_csv:String)
		{
			MySharedObjectConstant.setCategory(category_csv);
			_category = "./data/"+category_csv;
			
			var songlist:SmoothingBitmapLoader = new SmoothingBitmapLoader(getFullPath(loaderInfo) +"songlist.swf");
			songlist.addEventListener(SmoothingBitmapLoader.INIT,function onLoaded(e:Event)
			{
			songlist.removeEventListener(SmoothingBitmapLoader.INIT,onLoaded);
			songlist.loaderContent.updateCategory(getFullPath(loaderInfo) +_category);
			songlist.loaderContent.addEventListener(SongListEvent.SONG_LIST,onSongList);
			addChild(songlist);
			songlist.loaderContent.addEventListener(MyEvent.GO_TO_PREVIOUS_PAGE,function gotoPreviousPage(e:Event)
			{
			while(numChildren>0)
			{
			removeChildAt(0);
			}
			createCategoryList();
			});
			});
		}
		
		function onCategoryList(e:SongListEvent)
		{
			//Logger.debug("onCategoryList ",e.data);
			//category.loaderContent.removeEventListener(SongListEvent.SONG_CATEGORY,onCategoryList);
			//removeChild(e.target as SmoothingBitmapLoader);
			while (numChildren>0)
			{
				removeChildAt(0);
			}
			createSongList(e.data);
		
		
		
		
		}
		function onSongList(e:SongListEvent)
		{
			//Logger.debug("onSongList ",e.data);
			var _data:Object = e.data as Object;
			//e.target.loaderContent.removeEventListener(SongListEvent.SONG_LIST,onSongList);
			while (numChildren>0)
			{
				removeChildAt(0);
			}
		
			//Logger.debug(getFullPath(loaderInfo) +"player.swf");
			var player:SmoothingBitmapLoader = new SmoothingBitmapLoader(getFullPath(loaderInfo) +"player.swf");
			player.addEventListener(SmoothingBitmapLoader.INIT,function onLoaded(e:Event)
			{
			
				
			player.removeEventListener(SmoothingBitmapLoader.INIT,onLoaded);
			player.loaderContent.artist_tf.text=_data.ARTIST;
			player.loaderContent.songname_tf.text="｢"+_data.SONG_NAME+"｣";
				var songFile:String = _data.FILE;
				
				MySharedObjectConstant.setSongPath(songFile);
			var cover_:SmoothingBitmapLoader = new SmoothingBitmapLoader(getFullPath(loaderInfo) +_data.COVER);
			cover_.addEventListener(SmoothingBitmapLoader.INIT,function onLoaded(e:Event)
									{
										cover_.width = player.loaderContent.conver_mc.width;
										cover_.height = player.loaderContent.conver_mc.height;
										player.loaderContent.conver_mc.addChild(cover_);
									});
			
			
			
			player.loaderContent.addEventListener(MyEvent.GO_TO_NEXT_PAGE,function gotoNextPage(e:Event)
			{
				
				Logger.debug(MySharedObjectConstant.getSongPath());
				while(numChildren>0)
				{
					removeChildAt(0);
				}
				/*dispatchEvent(new Event(MyEvent.GO_TO_NEXT_PAGE)); 
				addEventListener(SongListEvent.SONG_CONFIRM,onSongConfirm);
				dispatchEvent(new SongListEvent(SongListEvent.SONG_CONFIRM,_data)); */
				
			});
			player.loaderContent.addEventListener(MyEvent.GO_TO_PREVIOUS_PAGE,function gotoPreviousPage(e:Event)
			{
				while(numChildren>0)
				{
					removeChildAt(0);
				}
				//createCategoryList();
				createSongList(_category);
			});
			addChild(player);
			
			});
		}
		function onSongConfirm(e:SongListEvent)
		{
			removeEventListener(SongListEvent.SONG_CONFIRM,onSongConfirm);
			var _data:Object = e.data as Object;
			Logger.debug("onSongConfirm ",_data.FILE);
		
		}
		
		
		function init(e:Event = null):void
		{
			stage.removeEventListener(Event.ADDED_TO_STAGE, init);
		
		
		}
		function getFullPath(loaderInfo:LoaderInfo):String
		{
			var myObsolutePath:String;
			var myRelativePath:String;
			//Logger.debug(loaderInfo.url);
			myObsolutePath = loaderInfo.url;
		
			var stringStart:Number = 0;
			var stringEnd:Number = myObsolutePath.lastIndexOf("/") + 1;
		
			myRelativePath = myObsolutePath.slice(stringStart,stringEnd);
		
			return myRelativePath;
		}
	}
	
}

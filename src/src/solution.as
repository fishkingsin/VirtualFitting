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
		var _data:Object;
		var category_data:Object;
		
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
			try{
				Logger.debug("solution : removeAll Child");
				trace("solution : removeAll Child");
				while(numChildren>0)
				{
					removeChildAt(0);
				}
			}catch (e: * )
			{
				trace("solution destory error:"+e.toString());
			}
		}

		function createCategoryList()
		{
			var categoryList:SmoothingBitmapLoader = new SmoothingBitmapLoader(getFullPath(loaderInfo) +"category.swf");
			categoryList.addEventListener(SmoothingBitmapLoader.INIT,function onLoaded(e:Event)
			{
				categoryList.removeEventListener(SmoothingBitmapLoader.INIT,onLoaded);
				addChild(categoryList);
				
				categoryList.loaderContent.addEventListener(SongListEvent.SONG_CATEGORY,function onCategoryList(e:SongListEvent)
				{
					categoryList.remove();
					//Logger.debug("onCategoryList ",e.data);
					//category.loaderContent.removeEventListener(SongListEvent.SONG_CATEGORY,onCategoryList);
					//removeChild(e.target as SmoothingBitmapLoader);
					while (numChildren>0)
					{
						removeChildAt(0);
					}
					createSongList(e.data);
				
				
				
				
				});
			});
		}
		function createSongList(category_csv:Object)
		{
			
			category_data = category_csv;
			trace(category_data);
			MySharedObjectConstant.setCategory(category_data.FILE);
			//_category = category_csv.FILE;
			//_title = category_csv.SONG_NAME;
			var songlist:SmoothingBitmapLoader = new SmoothingBitmapLoader(getFullPath(loaderInfo) +"songlist.swf");
			songlist.addEventListener(SmoothingBitmapLoader.INIT,function onLoaded(e:Event)
			{
				songlist.removeEventListener(SmoothingBitmapLoader.INIT,onLoaded);
				songlist.loaderContent.updateCategory(category_data.SONG_NAME , "./data/"+category_data.FILE);
					
				songlist.loaderContent.addEventListener(SongListEvent.SONG_LIST,onSongList);
				addChild(songlist);
				songlist.loaderContent.addEventListener(MyEvent.GO_TO_PREVIOUS_PAGE,function gotoPreviousPage(e:Event)
				{
					songlist.remove();
					while(numChildren>0)
					{
						removeChildAt(0);
					}
					createCategoryList();
				});
			});
		}
		
		
		function onSongList(e:SongListEvent)
		{
			//Logger.debug("onSongList ",e.data);
			_data = e.data as Object;
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
				createSongList(category_data);
			});
			addChild(player);
			
			});
		}
		function onSongConfirm(e:SongListEvent)
		{
			removeEventListener(SongListEvent.SONG_CONFIRM,onSongConfirm);
			 _data = (e.data as Object);
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

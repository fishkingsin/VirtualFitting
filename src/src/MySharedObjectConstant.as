package {
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.NetStatusEvent;
    import flash.net.SharedObject;
    import flash.net.SharedObjectFlushStatus;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
	import 	flash.net.SharedObject;
    import net.hires.debug.Logger;
    public class MySharedObjectConstant  {
        
		public static const KEY_HOST = "virtualfitting";
		public static const TAG = "MySharedObjectConstant";
		public static const UPLOAD_COMPLETE:String = "upload_complete";
		function MySharedObjectConstant()
		{
			
		}
		public static function save(TAG:String , mySo:SharedObject)
		{
			var flushResult = mySo.flush();
			
			Logger.debug(TAG + " flushResult: " + flushResult);
		}
		public static function load()
		{
			
		}
		public static function setSongName(songName:String)
		{
			var mySo = SharedObject.getLocal(KEY_HOST,"/");
			
			mySo.data.songname = songName;
			
			save("setSongName", mySo);
		}
		public static function getSongName():*
		{
			var mySo = SharedObject.getLocal(KEY_HOST,"/");
			Logger.debug(TAG,"getSongName - "+mySo.data.songname);
			return mySo.data.songname;
		}
		public static function setCoverPath(coverPath:String)
		{
			var mySo = SharedObject.getLocal(KEY_HOST,"/");
			
			mySo.data.coverpath = coverPath;
			
			save("setCoverPath", mySo);
		}
		public static function getCoverPath():*
		{
			var mySo = SharedObject.getLocal(KEY_HOST,"/");
			Logger.debug(TAG,"getCoverPath - "+mySo.data.coverpath);
			return mySo.data.coverpath;
		}
		public static function setArtistName(artistName:String)
		{
			var mySo = SharedObject.getLocal(KEY_HOST,"/");
			
			mySo.data.artistname = artistName;
			
			save("setCoverPath", mySo);
		}
		public static function getArtistName():*
		{
			var mySo = SharedObject.getLocal(KEY_HOST,"/");
			Logger.debug(TAG,"getArtistName - "+mySo.data.artistname);
			return mySo.data.artistname;
		}
		public static function setSongPath(songPath:String)
		{
			var mySo = SharedObject.getLocal(KEY_HOST,"/");
			
			mySo.data.songpath = songPath;
			
			save("setSongPath", mySo);
		}
		public static function getSongPath():*
		{
			var mySo = SharedObject.getLocal(KEY_HOST,"/");
			
			Logger.debug(TAG,"getSongPath - "+mySo.data.songpath);

			return mySo.data.songpath;
		}
		public static function setSavedPhotos(savedPhotos:Array)
		{
			var mySo = SharedObject.getLocal(KEY_HOST,"/");
			
			mySo.data.savedphotos = savedPhotos;
						
			save("setSavedPhotos", mySo);
		}
		
		public static function getSavedPhotos():Array
		{
			var mySo = SharedObject.getLocal(KEY_HOST,"/");
			Logger.debug(TAG,"getSavedPhotos - "+mySo.data.savedphotos);
			return mySo.data.savedphotos;
		}
		
		
		public static function setSavedPhoto(savedPhoto:String)
		{
			var mySo = SharedObject.getLocal(KEY_HOST,"/");
			
			mySo.data.savedphoto = savedPhoto;
						
			save("setSavedPhotos", mySo);
		}
		
		public static function getSavedPhoto():String
		{
			var mySo = SharedObject.getLocal(KEY_HOST,"/");
			Logger.debug(TAG,mySo.data.savedphoto);
			return mySo.data.savedphoto;
		}
		
		public static function setCategory(Category:String)
		{
			var mySo = SharedObject.getLocal(KEY_HOST,"/");
			
			mySo.data.Category = Category;
						
			save("setCategory"+" "+mySo.data.Category, mySo );
		}
		
		public static function getCategory():String
		{
			var mySo = SharedObject.getLocal(KEY_HOST,"/");
			
			return mySo.data.Category;
		}
		/*function SharedObject_flush() {
			var mySo = SharedObject.getLocal(hostName);
			Logger.debug(TAG,mySo.data.cover_path);
			Logger.debug(TAG,mySo.data.username); // yourUsername
			
			mySo.data.username = username;
			mySo.data.cover_path = cover_path;
			var flushResult = mySo.flush();
			
			Logger.debug(TAG,"flushResult: " + flushResult);
			Logger.debug(TAG,mySo.data.username); // yourUsername
			Logger.debug(TAG,mySo.data.cover_path);
		}*/
    }
}
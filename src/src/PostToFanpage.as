﻿package 
	import net.hires.debug.Logger;
			if(stage)
			{
				addChild(new Logger());
			}
				Logger.debug(response.toString());
				if(isPostToPage)
				{
				}
				else
				{
					var savedphoto:String = MySharedObjectConstant.getSavedPhoto();
					if(savedphoto!=null)
					{
						fileUpLoad(savedphoto,ALBUM_ID,access_token);
	
					}
					else
					{
					}
				}
			var savedphoto:String = MySharedObjectConstant.getSavedPhoto();
				if(savedphoto!=null)
				{
					fileUpLoad(savedphoto,ALBUM_ID,page_access_token);

				}
				else
				{
					fileUpLoad("./data/temp.png",ALBUM_ID,page_access_token);
				}
			var now:Date = new Date();
			var timestamp:String = now.valueOf().toString();
			var path:String = "/data/"+timestamp+".png"
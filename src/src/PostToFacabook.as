﻿package 
	import net.hires.debug.Logger;
			if(stage)
			{
				addChild(new Logger());
			}
				Logger.debug(response.toString());
				var savedphoto:String = MySharedObjectConstant.getSavedPhoto();
				if(savedphoto!=null)
				{
					fileUpLoad(savedphoto,ALBUM_ID,access_token);

				}
				else
				{
				}
			var now:Date = new Date();
			var timestamp:String = now.valueOf().toString();
			var path:String = "/data/"+timestamp+".png"
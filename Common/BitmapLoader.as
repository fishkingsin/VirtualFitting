﻿package 
			trace("SmoothingBitmapLoader onRemoved() : "+name);
			removeEventListener(Event.REMOVED_FROM_STAGE ,onRemoved);
			//remove();
			trace("SmoothingBitmapLoader remove() : "+name);
			try{
			if ( _url.search(".png")>0 || _url.search(".jpg")>0)
				{

					var bmp:Bitmap = Bitmap(imgLoader.content);
					bmp.bitmapData.dispose();

				}
			}
			catch(e:*)
			{
				trace(e.toString());
			}
			try
			{
			}
			catch(e:*)
			{
				trace(e.toString());
			}
﻿package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	import com.adobe.images.PNGEncoder;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import net.hires.debug.Logger;
	public class selectcover extends MovieClip {
		
		var thumbnails:Array=new Array();
		private static const myPath:String = "./data/images/"
		//var btn1:customButton;
		//var btn2:customButton;
		var index= 0;
		var WIDTH = 447;//cover.width;
			var HEIGHT = 729;//cover.height;
		var thumbs:Array
		public function selectcover() {
		if (stage)
			{
				createGallery();
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
			createGallery();

		}
		function onRemoved(e:Event):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE,onRemoved);
			try{
				
				/*for each(var loader:BitmapLoader in thumbnails)
				{
					loader.remove();
				}*/
				Logger.debug("selectcover : removeAll Child");
				trace("selectcover : removeAll Child");
				while(numChildren>0)
				{
					removeChildAt(0);
				}
			}catch (e: * )
			{
				trace("selectcover remove child error:"+e.toString());
			}
			try{
				while(thumbnails.length>0)
				{
					thumbnails.pop();
				}
			}catch (e: * )
			{
				trace("selectcover thumbnails error:"+e.toString());
			}
			try{
				while(thumbs.length>0)
				{
					thumbs.pop();
				}
			}catch (e: * )
			{
				trace("selectcover thumbs error:"+e.toString());
			}
		
		}



		function createGallery(){
			thumbs = MySharedObjectConstant.getSavedPhotos();
			if(thumbs==null)
			{
				//return;
				thumbs = ["./data/temp.png",
				"./data/temp 2.png",
				"./data/temp 3.png",
				"./data/temp 4.png",
				"./data/temp 5.png"];
			}
			
				
			for each (var t:String in thumbs)
			{
				var s:BitmapLoader = new BitmapLoader(t);
				s.addEventListener(BitmapLoader.INIT,function onLoaded(e:Event)
				{
					//if(t==thumbs[0])
					var b:BitmapLoader = e.target as BitmapLoader;
					thumbnails.push(b);
					if(thumbnails.length==1){
						
													
						
						b.loaderContent.width = WIDTH;
						b.loaderContent.height = HEIGHT;
						cover.addChild(b);
						
					}
				});
			}
			
			
			var xml1:XML=<BUTTON name="button_back">
				<SHOW_LABLE>0</SHOW_LABLE><X>61</X><Y>489</Y>
				<IMAGES>
				<FILE>{myPath+"btn_image_small_square.png"}</FILE>
				<FILE>{myPath+"btn_image_small_square.png"}</FILE>
				</IMAGES>
				<CAPTION>
				<CHIT>undefined</CHIT>
				</CAPTION>
				<NEXT_PAGE></NEXT_PAGE>
				<MESSAGE>0</MESSAGE>;
				</BUTTON>;
			
			var btn1:customButton = new customButton(xml1,1);
			addChild(btn1);
			btn1.addEventListener(MouseEvent.CLICK,onClick);
				
			var xml2:XML=<BUTTON name="button_next">
				<SHOW_LABLE>0</SHOW_LABLE><X>588</X><Y>489</Y>
				<IMAGES>
				<FILE>{myPath+"btn_image_small_square.png"}</FILE>
				<FILE>{myPath+"btn_image_small_square.png"}</FILE>
				</IMAGES>
				<CAPTION>
				<CHIT>undefined</CHIT>
				</CAPTION>
				<NEXT_PAGE></NEXT_PAGE>
				<MESSAGE>0</MESSAGE>;
				</BUTTON>;
			
			var btn2:customButton = new customButton(xml2,1);
			addChild(btn2);
			btn2.addEventListener(MouseEvent.CLICK, onClick);
				
				
				
				var xml_confrim:XML=<BUTTON name="button_confirm">
				<SHOW_LABLE>0</SHOW_LABLE><X>299</X><Y>969</Y>
				<IMAGES>
				<FILE>{myPath+"button_confirm.png"}</FILE>
				<FILE>{myPath+"button_confirm.png"}</FILE>
				</IMAGES>
				<CAPTION>
				<CHIT>undefined</CHIT>
				</CAPTION>
				<NEXT_PAGE>inputmessage</NEXT_PAGE>
				<MESSAGE>0</MESSAGE>;
				</BUTTON>;
			
			var buttonconfirm:customButton = new customButton(xml_confrim,1);
			buttonconfirm.addEventListener(MouseEvent.CLICK, function onClick(e:MouseEvent)
			{
				MySharedObjectConstant.setSavedPhoto(thumbs[index]);
				
				var s:SmoothingBitmapLoader = new SmoothingBitmapLoader("./confirmcover.swf");
				s.addEventListener(SmoothingBitmapLoader.INIT,function onLoaded(e:Event)
				{
					s.loaderContent.cover.cover_main.addChild(thumbnails[index]);
					s.loaderContent.addEventListener(MyEvent.GO_TO_PREVIOUS_PAGE,function onBack(e:Event)
					{
						//var sprite:Sprite = e.target as Sprite;
						removeChild(s);
						cover.addChild(thumbnails[index]);
					});

					s.loaderContent.addEventListener(MyEvent.GO_TO_NEXT_PAGE,function onNext(e:Event)
					{
						MySharedObjectConstant.setSavedPhoto(captureAndSave(s.loaderContent.cover));
						
						var fb:SmoothingBitmapLoader = new SmoothingBitmapLoader("./postfacebook.swf");
						
						fb.addEventListener(SmoothingBitmapLoader.INIT,function onLoaded(e:Event)
						{
							fb.loaderContent.addEventListener(MySharedObjectConstant.UPLOAD_COMPLETE,function onUploadComplete(e:Event)
							{
								fb.loaderContent.removeEventListener(MySharedObjectConstant.UPLOAD_COMPLETE, onUploadComplete);
								dispatchEvent(new Event(MySharedObjectConstant.UPLOAD_COMPLETE));
							});
							fb.loaderContent.addEventListener(MyEvent.GO_TO_NEXT_PAGE,function onNext(e:Event)
							{
								fb.loaderContent.removeEventListener(MyEvent.GO_TO_NEXT_PAGE, onNext);
								dispatchEvent(new Event(MyEvent.GO_TO_NEXT_PAGE));
								//removeChild(fb);
								
							});
							removeChild(s);
							addChild(fb);
						});
						
					});
					
					var i:uint = 0;
					for each(var img:BitmapLoader in thumbnails)
					{
						if(img!=thumbnails[index])
						{
							img.loaderContent.width = 138;
							img.loaderContent.height = 182;
							if(i==0)s.loaderContent.cover.cover_1.addChild(img);
							if(i==1)s.loaderContent.cover.cover_2.addChild(img);
							if(i==2)s.loaderContent.cover.cover_3.addChild(img);
							if(i==3)s.loaderContent.cover.cover_4.addChild(img);
							i++;
						}
					}
					
					
					addChild(s);
				});
				
			});
			addChild(buttonconfirm);
		}
		function onClick(e:MouseEvent)
		{
			if(e.target.name=="button_back")
			{
				
					index--;
				if(index<0)index=0;
					thumbnails[index].loaderContent.width = WIDTH;
					thumbnails[index].loaderContent.height = HEIGHT;
					cover.addChild(thumbnails[index]);
					bar.gotoAndStop(index+1);
				
			}
			if(e.target.name=="button_next")
			{
				//cover.addChild(thumbnails[index]);
				index++;
				if(index>thumbnails.length-1)index = thumbnails.length-1;
				
					thumbnails[index].loaderContent.width = WIDTH;
						thumbnails[index].loaderContent.height = HEIGHT;
					cover.addChild(thumbnails[index]);
					bar.gotoAndStop(index+1);
				
			}
		}
		
		protected function captureAndSave(mc:MovieClip):String
		{
			var _bitmapData:BitmapData = new BitmapData(584,732);
			_bitmapData.draw(mc);
			var now:Date = new Date();
			var timestamp:String = now.valueOf().toString();
			var path:String = "/capture2/"+timestamp+".png"
			
			var file:File = new File(File.applicationDirectory.nativePath + path);

			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(PNGEncoder.encode(_bitmapData));
			stream.close();
			_bitmapData.dispose();
			return path;
		}
		
		
		
	}
	
}




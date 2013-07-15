package {	import flash.display.MovieClip;	import com.facebook.graph.FacebookDesktop;	import com.adobe.serialization.json.JSON;	import flash.net.URLRequest;	import flash.net.URLRequestMethod;	import flash.net.URLVariables;	import flash.net.SharedObject;	import flash.filesystem.File;	import flash.filesystem.FileStream;	import flash.filesystem.FileMode;	import flash.events.Event;
	import flash.events.MouseEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	import com.parsera.net.NetLoader;
	import net.hires.debug.Logger;	public class PostToFacabook extends MovieClip	{
				private static const myPath:String = "./data/images/"		protected static const APP_ID:String = "405938312786016";// Your App ID.		protected static const ALBUM_ID:String = "me";// Your App ID.		//protected static const ALBUM_ID:String = "229661030501037";// Your App ID.				protected static const APP_ORIGIN:String = "http://stormy-snow-6379.herokuapp.com/";// The site URL of your application (specified in your app settings); needed for clearing cookie when logging out.		var access_token:String;		var page_access_token;
		var btn1:customButton = null;
		var circle:SmoothingBitmapLoader;
		var coverflow:SmoothingBitmapLoader;		public function PostToFacabook()		{
			stop();			// constructor code			FacebookDesktop.init(APP_ID,handleInit);			
			if(stage)
			{
				init();
				
			}		else
			{
				addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			}
		}
		function onAdded(e:Event):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			init();

		}
		function onRemoved(e:Event):void
		{

			removeEventListener( Event.REMOVED_FROM_STAGE,onRemoved);
			try{
				circle.remove();
				Logger.debug("postfacebook : removeAll Child");
				trace("postfacebook : removeAll Child");
				while(numChildren>0)
				{
					removeChildAt(0);
				}
			}catch (e: * )
			{
				trace("gamecore destory error:"+e.toString());
			}
		
		}
		private function init()
		{
			
			
			coverflow = new SmoothingBitmapLoader("coverflow.swf");
			addChild(coverflow);
			
			button_login.addEventListener(MouseEvent.CLICK,function onLoginClick(e:MouseEvent){
				
				button_login.visible = false;
				button_login.removeEventListener(MouseEvent.CLICK, onLoginClick);
					FacebookDesktop.login(handleLogin,['manage_pages','user_photos', 'publish_stream' , 'user_likes' , 'read_stream']);
			});
			circle = new SmoothingBitmapLoader("./circle.swf");
			stop();
			var xml1:XML=<BUTTON name="postfacebook_btn_back">
			<SKIP_VIDEO>1</SKIP_VIDEO>
			
			<SHOW_LABLE>0</SHOW_LABLE><X>292</X><Y>624</Y>
			<IMAGES>
				<FILE>{myPath+"start_btn.png"}</FILE>
				<FILE>{myPath+"start_btn.png"}</FILE>
				</IMAGES>
			<CAPTION>
				<CHI>undefined</CHI>
			</CAPTION>
			<NEXT_PAGE>index</NEXT_PAGE>
			<MESSAGE>B</MESSAGE>
		</BUTTON>;
			
			btn1 = new customButton(xml1,1);
			
			
			btn1.addEventListener(MouseEvent.CLICK, function onClick(e:MouseEvent)
			{
				btn1.addEventListener(MouseEvent.CLICK, onClick);
				dispatchEvent(new Event(MyEvent.GO_TO_NEXT_PAGE));
				try{
				removeChild(btn1);
				}catch(e:*)
				{
					trace(e.toString());
					Logger.info(e.toString());
				}
			});
		}
		/*<BUTTON name="postfacebook_btn_back">
			<SKIP_VIDEO>1</SKIP_VIDEO>
			
			<SHOW_LABLE>0</SHOW_LABLE><X>292</X><Y>624</Y>
			<IMAGES>
				<FILE>./data/images/start_btn.png</FILE>
				<FILE>./data/images/start_btn.png</FILE>
			</IMAGES>
			<CAPTION>
				<CHI>undefined</CHI>
			</CAPTION>
			<NEXT_PAGE>index</NEXT_PAGE>
			<MESSAGE>B</MESSAGE>
		</BUTTON>*/
				function handleInit(response:Object,fail:Object):void		{			LogResponse(response,fail);			if (response)			{				//loginBtn.visible = false;				access_token = response.accessToken;							}		}		function handleLogin(response:Object,fail:Object):void		{			trace(response,fail);			if (response)			{
				Logger.debug(response.toString());				access_token = response.accessToken;				//loadImageToFile("pano.png");				//getPageAccessToken();
				var savedphoto:String = MySharedObjectConstant.getSavedPhoto();
				if(savedphoto!=null)
				{
					fileUpLoad(savedphoto,ALBUM_ID,access_token);

				}
				else
				{					fileUpLoad("./data/temp.png",ALBUM_ID,access_token);
				}
				addChild(circle);
				circle.x = 360;
				circle.y = 640;				//processButtonAction(minterface.getButtonByName("btn_login") as customButton );			}			else if (fail)			{				if(fail=="user-canceled")
				{
					gotoAndStop(2);
					coverflow.remove();
					removeChild(coverflow);
					addChild(btn1);
					dispatchEvent(new Event(MySharedObjectConstant.UPLOAD_COMPLETE));
					
				}				//logout( handleLogout);				try				{					FacebookDesktop.logout(handleLogout,APP_ORIGIN);					FacebookDesktop.manageSession = false;					var so:SharedObject = SharedObject.getLocal('com.facebook.graph.FacebookDesktop');					Logger.debug(so.toString());					so.clear();					so.flush();					dispatchEvent(new Event(MySharedObjectConstant.UPLOAD_COMPLETE));					//FacebookDesktop.init(APP_ID,handleInit);					//FacebookDesktop.logout(handleLogout, "https://m.facebook.com/dialog/permissions.request?app_id=APP_ID&display=touch&next=http%3A%2F%2Fwww.facebook.com%2Fconnect%2Flogin_success.html&type=user_agent&perms=publish_stream&fbconnect=1");				}				catch (error:Error)				{					Logger.debug(error.message);				}
							}		}		function LogResponse(response:Object,fail:Object=null)		{			Logger.debug("response "+JSON.stringify(response));			Logger.debug(JSON.stringify(response));			if (fail!=null)			{				Logger.debug("fail "+JSON.stringify(fail));			}		}		public function logout(handler:Function = null):void		{			var uri:String = APP_ORIGIN;//"https://www.facebook.com/MyFirstFacebookApp"			var params:URLVariables = new URLVariables();			params.next = uri;			//if (FacebookDesktop.getSession())			{				params.access_token = access_token;//FacebookDesktop.getSession().accessToken;			}			var req:URLRequest = new URLRequest("https://www.facebook.com/logout.php");			req.method = URLRequestMethod.GET;			req.data = params;			var netLoader:NetLoader = new NetLoader();			netLoader.load(req);			try{				FacebookDesktop.logout(handler, APP_ORIGIN);			}			catch(error:Error)			{				Logger.debug(error.message);			}					}		function handleLogout(response:Object):void		{			Logger.debug(response.toString());		}		/*function loadImageToFile(__url:String)		{						fileUpLoad(file);		}*/		function getPageAccessToken()		{			var params:Object  = new Object();			//params.input_token = access_token;						///oauth/access_token?//     client_id={app-id}//    &client_secret={app-secret}//    &grant_type=client_credentials			//params.client_id='361158920631434';//			params.client_secret='d189df495a711978b1e1b2fbbf027104';//			params.grant_type='client_credentials';						//FacebookDesktop.api('/229661030501037',handleGetAccessToken,params,'GET');			FacebookDesktop.api('/me/accounts',handleGetAccessToken,params,'GET');		}		protected function handleGetAccessToken(response:Object,fail:Object):void		{			Logger.debug("response "+response);			page_access_token = response[0].access_token;			Logger.debug("page_access_token "+page_access_token);			//logout( handleLogout);			fileUpLoad("pano.png",ALBUM_ID,page_access_token);		}		function fileUpLoad(__url:* , album_id:* , page_accesstoken:*)		{			Logger.debug(File.applicationDirectory.nativePath  +"/"+  __url);			var file:File = new File(File.applicationDirectory.nativePath + "/" + __url);						var params:Object  = new Object();			params.message = "想知道自己係Pop, Rock定Country Style？快啲去荃灣廣場全新Concept Store – FM STUDIO玩啦!\nhttps:\/\/www.facebook.com\/TsuenWanPlaza";
			var now:Date = new Date();
			var timestamp:String = now.valueOf().toString();
			var path:String = "/data/"+timestamp+".png"			params.fileName = timestamp;			params.image = file;			params.access_token = page_accesstoken;			FacebookDesktop.api('/'+album_id+'/photos',handleUploadComplete,params,'POST');		}		protected function handleUploadComplete(response:Object,fail:Object):void		{			var status = response ? 'Successfully uploaded':'Error uploading';			Logger.debug(status);			//Logger.debug(fail.toString());			logout( handleLogout);			gotoAndStop(2);
			coverflow.remove();
			removeChild(coverflow);
			addChild(btn1);
			dispatchEvent(new Event(MySharedObjectConstant.UPLOAD_COMPLETE));			removeChild(circle);		}		private function loadURL( url:String ):void		{			var loader:URLLoader = new URLLoader();			var request:URLRequest = new URLRequest(url);			//create any form vars to be posted to server side script			var form:URLVariables = new URLVariables();			form.postVar = "https://www.facebook.com/TsuenWanPlaza";			request.method = 'POST';			request.data = form;			//initialize data loader    			loader.dataFormat = "text";			loader.addEventListener(Event.COMPLETE, handleReturnResponse );			//request the document text			loader.load(request);		}		private function handleReturnResponse( event:Event ):void		{			Logger.debug( XML(event.target).toXMLString() );		}	}}
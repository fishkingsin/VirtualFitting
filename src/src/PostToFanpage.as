package {	import flash.display.MovieClip;	import com.facebook.graph.FacebookDesktop;	import com.adobe.serialization.json.JSON;	import flash.net.URLRequest;	import flash.net.URLRequestMethod;	import flash.net.URLVariables;	import flash.net.SharedObject;	import flash.filesystem.File;	import flash.filesystem.FileStream;	import flash.filesystem.FileMode;	import flash.events.Event;	import flash.net.URLLoader;	import flash.net.URLRequest;	import com.parsera.net.NetLoader;
	import net.hires.debug.Logger;	public class PostToFanpage extends MovieClip	{		protected static const APP_ID:String = "405938312786016";// Your App ID.		//protected static const ALBUM_ID:String = "me";// Your App ID.		protected static const ALBUM_ID:String = "538561689513517";// Your App ID.		var isPostToPage:Boolean=true;		protected static const APP_ORIGIN:String = "http://stormy-snow-6379.herokuapp.com/";// The site URL of your application (specified in your app settings); needed for clearing cookie when logging out.		var access_token:String;		var page_access_token;		public function PostToFanpage()		{			// constructor code			FacebookDesktop.init(APP_ID,handleInit);			FacebookDesktop.login(handleLogin,['manage_pages','user_photos', 'publish_stream' , 'user_likes' , 'read_stream']);
			if(stage)
			{
				addChild(new Logger());
			}		}		function handleInit(response:Object,fail:Object):void		{			LogResponse(response,fail);			if (response)			{				access_token = response.accessToken;							}		}		function handleLogin(response:Object,fail:Object):void		{			LogResponse(response,fail);			if (response)			{
				Logger.debug(response.toString());				access_token = response.accessToken;				
				if(isPostToPage)
				{					getPageAccessToken();
				}
				else
				{
					var savedphoto:String = MySharedObjectConstant.getSavedPhoto();
					if(savedphoto!=null)
					{
						fileUpLoad(savedphoto,ALBUM_ID,access_token);
	
					}
					else
					{						fileUpLoad("./data/temp.png",ALBUM_ID,access_token);
					}
				}							}			else if (fail)			{				try				{					FacebookDesktop.logout(handleLogout,APP_ORIGIN);					FacebookDesktop.manageSession = false;					var so:SharedObject = SharedObject.getLocal('com.facebook.graph.FacebookDesktop');					Logger.debug(so.toString());					so.clear();					so.flush();				}				catch (error:Error)				{					Logger.debug(error.message);				}			}		}		function LogResponse(response:Object,fail:Object=null)		{			Logger.debug("response "+JSON.stringify(response));			Logger.debug(JSON.stringify(response));			if (fail!=null)			{				Logger.debug("fail "+JSON.stringify(fail));			}		}		public function logout(handler:Function = null):void		{			var uri:String = "https://stormy-snow-6379.herokuapp.com/"			var params:URLVariables = new URLVariables();			params.next = uri;			//if (FacebookDesktop.getSession())			{				params.access_token = access_token;//FacebookDesktop.getSession().accessToken;			}			var req:URLRequest = new URLRequest("https://www.facebook.com/logout.php");			req.method = URLRequestMethod.GET;			req.data = params;			var netLoader:NetLoader = new NetLoader();			netLoader.load(req);			try{				FacebookDesktop.logout(handler, APP_ORIGIN);			}			catch(error:Error)			{				Logger.debug(error.message);			}					}		function handleLogout(response:Object):void		{			Logger.debug(response.toString());		}		/*function loadImageToFile(__url:String)		{						fileUpLoad(file);		}*/		function getPageAccessToken()		{			var params:Object  = new Object();			//params.input_token = access_token;						///oauth/access_token?//     client_id={app-id}//    &client_secret={app-secret}//    &grant_type=client_credentials			//params.client_id='361158920631434';//			params.client_secret='d189df495a711978b1e1b2fbbf027104';//			params.grant_type='client_credentials';						//FacebookDesktop.api('/229661030501037',handleGetAccessToken,params,'GET');			FacebookDesktop.api('/me/accounts',handleGetAccessToken,params,'GET');		}		protected function handleGetAccessToken(response:Object,fail:Object):void		{			Logger.debug("response "+response);			page_access_token = response[0].access_token;			Logger.debug("page_access_token "+page_access_token);			//logout( handleLogout);
			var savedphoto:String = MySharedObjectConstant.getSavedPhoto();
				if(savedphoto!=null)
				{
					fileUpLoad(savedphoto,ALBUM_ID,page_access_token);

				}
				else
				{
					fileUpLoad("./data/temp.png",ALBUM_ID,page_access_token);
				}					}		function fileUpLoad(__url:* , album_id:* , page_accesstoken:*)		{			Logger.debug(File.applicationDirectory.nativePath  +"/"+  __url);			var file:File = new File(File.applicationDirectory.nativePath + "/" + __url);						var params:Object  = new Object();			params.message = "想知道自己係Pop, Rock定Country Style？快啲去荃灣廣場全新Concept Store – FM STUDIO玩啦!\nhttps:\/\/www.facebook.com\/TsuenWanPlaza";
			var now:Date = new Date();
			var timestamp:String = now.valueOf().toString();
			var path:String = "/data/"+timestamp+".png"			params.fileName = timestamp;			params.image = file;			params.access_token = page_accesstoken;			FacebookDesktop.api('/'+album_id+'/photos',handleUploadComplete,params,'POST');		}		protected function handleUploadComplete(response:Object,fail:Object):void		{			var status = response ? 'Successfully uploaded':'Error uploading';			Logger.debug(status);			//Logger.debug(fail.toString());			logout( handleLogout);			gotoAndStop(2);		}		private function loadURL( url:String ):void		{			var loader:URLLoader = new URLLoader();			var request:URLRequest = new URLRequest(url);			//create any form vars to be posted to server side script			var form:URLVariables = new URLVariables();			form.postVar = "https://www.facebook.com/TsuenWanPlaza";			request.method = 'POST';			request.data = form;			//initialize data loader    			loader.dataFormat = "text";			loader.addEventListener(Event.COMPLETE, handleReturnResponse );			//request the document text			loader.load(request);		}		private function handleReturnResponse( event:Event ):void		{			Logger.debug( XML(event.target).toXMLString() );		}	}}
package com.yuco.registration_terminals_g1b4.db{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class XMLClass extends EventDispatcher{
		
		private var xmlLoader:URLLoader;
		private var loadQueue:Array;
		private var loadXMLObject:Object;
		private var loadCounter:int;
		private var loading:Boolean;
		
		public function XMLClass():void{
			init();
		}
		
		private function init():void{
			loadQueue = new Array();
			loadXMLObject = new Object();
			loadCounter = 0;
			loading = false;
		}
		
		public function load( _filepath:String, _xmlIndex:String ):void{
			loadXMLObject[loadCounter] = new Object();
			loadXMLObject[loadCounter].filepath = _filepath;
			loadXMLObject[loadCounter].xmlIndex = _xmlIndex;
			
			loadQueue.push( loadXMLObject[loadCounter] );
						
			loadCounter++;
			
			if( loadQueue.length != 0 && !loading ){
				loadXML();
			}
		}
		
		private function loadXML():void{
			loading = true;
			var xmlLoaderHandler:Function = createXmlLoaderHandler( loadQueue[0].xmlIndex );
			
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener( Event.COMPLETE, xmlLoaderHandler );
			xmlLoader.load( new URLRequest( loadQueue[0].filepath ) );
		}
		
		
		private function createXmlLoaderHandler( _xmlIndex:String ):Function{
			var xmlLoaderHandler:Function = function( e:Event ):void{
				parseXML( new XML(e.target.data), _xmlIndex );
			}
			return xmlLoaderHandler;
		}
		
		private function parseXML( _xml:XML, _xmlIndex:String ):void{
			if( _xmlIndex == "db_config" ){
//				trace("init");
				ConstantClass.HOST = _xml.host;
				ConstantClass.USER_ID = _xml.id;
				ConstantClass.PASSWORD = _xml.password;
				ConstantClass.HOST_SPARE = _xml.host_spare;
				ConstantClass.USER_ID_SPARE = _xml.id_spare;
				ConstantClass.PASSWORD_SPARE = _xml.password_spare;
				ConstantClass.DB = _xml.db;
				ConstantClass.TABLE = _xml.table_g1b4;
				ConstantClass.PHP_FILE_PATH = _xml.php_file_path_g1b4;
			}else if( _xmlIndex == "" ){
			}
			
			loadQueue.splice( 0, 1 );
			loading = false;
			
			if( loadQueue.length != 0 && !loading ){
				loadXML();
			}else{
				dispatchEvent( new Event( ConstantClass.XML_LOAD_COMPLETE, true ) );
			}
		}
	}
}
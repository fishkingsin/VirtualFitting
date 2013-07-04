package com.yuco.registration_terminals_g1b4.db{
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	
	public class PHPLoaderClass extends EventDispatcher{
		
		private var urlRequest:URLRequest;
		private var urlLoader:URLLoader;
		private var qrKeyStatus:Boolean;
		private var insertStatus:Boolean;
		private var dataArray:Array;
//		var phpFile:String = "http://localhost/";
		
		public function PHPLoaderClass():void{
		}
		
		private function urlLoaderHandler( e:Event ):void{
//			trace("urlLoaderHandler = "+ e.target.data);
			var ba:ByteArray = e.target.data;
			var receiveMsg:String = ba.toString();
			var indexOfTypeBegin:int = receiveMsg.indexOf(";;;TYPE-BEGIN;;;");
			var indexOfTypeEnd:int = receiveMsg.indexOf(";;;TYPE-END;;;");
			
			switch( receiveMsg.substring( indexOfTypeBegin+";;;TYPE-BEGIN;;;".length, indexOfTypeEnd ) ){
				case "G_1_B4_CHECK_QRKEY":
					receiveMsg = receiveMsg.substring( indexOfTypeEnd+";;;TYPE-END;;;".length, receiveMsg.length );
					
					if( receiveMsg != "" ){
						if( receiveMsg == "True" ){
							qrKeyStatus = true;
						}else{
							qrKeyStatus = false;
						}
						
						dispatchEvent( new Event( ConstantClass.CHECK_QRKEY_COMPLETE, true ) );
					}
				break;
				
				case "G_1_B4_INSERT_DATA":
					receiveMsg = receiveMsg.substring( indexOfTypeEnd+";;;TYPE-END;;;".length, receiveMsg.length );
					
					if( receiveMsg != "" ){
						if( receiveMsg == "Success" ){
							insertStatus = true;
						}else{
							insertStatus = false;
						}
						
						dispatchEvent( new Event( ConstantClass.INSERT_DATA_COMPLETE, true ) );
					}
				break;
				
				case "G_1_B4_SEARCH_QRKEY":
					receiveMsg = receiveMsg.substring( indexOfTypeEnd+";;;TYPE-END;;;".length, receiveMsg.length );
					
					if( receiveMsg != "" ){
						dataArray = new Array();
						if( receiveMsg == "0" ){
							dataArray["Result"] = "No record";
						}else{
							dataArray["Result"] = "Success";
							var tempArray1:Array = receiveMsg.split(";;;");
							tempArray1.pop();
							
							var tempArray2:Array = new Array();
							for( var i:int=0;i<tempArray1.length;i++){
								tempArray2[i] = new Array();
								tempArray2[i] = tempArray1[i].split("!@#$%^");
							}
							
							for( var ii:int=0;ii<tempArray2.length;ii++){
								dataArray[tempArray2[ii][0].toString()] = tempArray2[ii][1];
							}
						}
						
						
						dispatchEvent( new Event( ConstantClass.LOAD_DATA_COMPLETE, true ) );
					}
				break;
				
				case "Connect Servers Fail!":
//					trace("Connect Servers Fail!");
					dataArray = new Array();
					dataArray["Result"] = "Connect Servers Fail!";
					dispatchEvent( new Event( ConstantClass.LOAD_DATA_COMPLETE, true ) );
				break;
			}
		}
		//==handler====================================================================================
		private function urlIOErrorHandler( e:IOErrorEvent ):void{
//			trace("urlIOErrorHandler");
		}
		
		//==public function============================================================================
		public function updatePhp( _phpFile:String, _var:URLVariables ):void{
//			urlRequest = new URLRequest( "http://"+ConstantClass.HOST+"/"+_phpFile );
			urlRequest = new URLRequest( _phpFile );
			urlLoader = new URLLoader();
			
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = _var;
			
//			urlLoader.dataFormat =URLLoaderDataFormat.VARIABLES;
//			urlLoader.dataFormat =URLLoaderDataFormat.TEXT;
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY; 
			
			urlLoader.addEventListener( Event.COMPLETE, urlLoaderHandler );
			urlLoader.addEventListener( IOErrorEvent.IO_ERROR, urlIOErrorHandler );
		
			urlLoader.load( urlRequest );
		}
		
		public function getQRKeyStatus():Boolean{
			return qrKeyStatus;
		}
		
		public function getInsertStatus():Boolean{
			return insertStatus;
		}
		
		public function getDataArray():Array{
			return dataArray;
		}
	}
}
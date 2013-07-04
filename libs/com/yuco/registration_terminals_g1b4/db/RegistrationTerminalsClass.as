package com.yuco.registration_terminals_g1b4.db{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLVariables;
	
	public class RegistrationTerminalsClass extends EventDispatcher{
		
		private var xmlClass:XMLClass;
		private var dataClass:DataClass;
		
		public function RegistrationTerminalsClass():void{
			init();
		}
		
		private function init():void{
			xmlClass = new XMLClass();
			xmlClass.addEventListener( ConstantClass.XML_LOAD_COMPLETE, xmlHandler );
			xmlClass.load( "db_config.xml", "db_config" );
			
			dataClass = new DataClass();
			dataClass.addEventListener( ConstantClass.CHECK_QRKEY_COMPLETE, dataHandler );
			dataClass.addEventListener( ConstantClass.INSERT_DATA_COMPLETE, dataHandler );
			dataClass.addEventListener( ConstantClass.LOAD_DATA_COMPLETE, dataHandler );
		}
		
		private function variableDefaultSetting():URLVariables{
			var vars:URLVariables = new URLVariables();
			
			vars.serverHost = ConstantClass.HOST;
			vars.userName = ConstantClass.USER_ID;
			vars.passWord = ConstantClass.PASSWORD;
			vars.serverHostSpare = ConstantClass.HOST_SPARE;
			vars.userNameSpare = ConstantClass.USER_ID_SPARE;
			vars.passWordSpare = ConstantClass.PASSWORD_SPARE;
			vars.dbName = ConstantClass.DB;
			vars.tblName = ConstantClass.TABLE;
			
			return vars;
		}
				
		//--handler-----------------------------------------------------------------------------------
		private function xmlHandler( e:Event ):void{			
			dispatchEvent( new Event( ConstantClass.XML_LOAD_COMPLETE, true ) );
		}
		
		private function dataHandler( e:Event ):void{
//			trace("DATA_HANDLE_COMPLETE!!!");
			if( e.type == ConstantClass.CHECK_QRKEY_COMPLETE ){
				dispatchEvent( new Event( ConstantClass.CHECK_QRKEY_COMPLETE, true ) );
			}else if( e.type == ConstantClass.INSERT_DATA_COMPLETE ){
				dispatchEvent( new Event( ConstantClass.INSERT_DATA_COMPLETE, true ) );
			}else if( e.type == ConstantClass.LOAD_DATA_COMPLETE ){
				dispatchEvent( new Event( ConstantClass.LOAD_DATA_COMPLETE, true ) );
			}
		}
		//--public function---------------------------------------------------------------------------
		public function checkQRKey( _qrKey:String ):void{
			var vars:URLVariables = variableDefaultSetting();
			
			vars.dataType = "G_1_B4_CHECK_QRKEY";
			vars.qrKey = _qrKey;
			dataClass.searchFromDB( vars );
		}
		
		public function insertData( _qrKey:String, _qID:String, _ans:String ):void{
			var vars:URLVariables = variableDefaultSetting();
			
			vars.dataType = "G_1_B4_INSERT_DATA";
			vars.qrKey = _qrKey;
			vars.qID = _qID;
			vars.ans = _ans;
			dataClass.searchFromDB( vars );
		}
		
		public function searchByQRKey( _qrKey:String ):void{
			var vars:URLVariables = variableDefaultSetting();
			
			vars.dataType = "G_1_B4_SEARCH_QRKEY";
			vars.qrKey = _qrKey;
			
			dataClass.searchFromDB( vars );
		}
				
		public function getQRKeyStatus():Boolean{
			return dataClass.getQRKeyStatus();
		}
		
		public function getInsertStatus():Boolean{
			return dataClass.getInsertStatus();
		}
		
		public function getDataArray():Array{
			return dataClass.getDataArray();
		}
	}
}
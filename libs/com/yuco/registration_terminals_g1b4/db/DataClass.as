package com.yuco.registration_terminals_g1b4.db{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLVariables;
	
	public class DataClass extends EventDispatcher{
	
		private var phpLoaderClass:PHPLoaderClass;
			
		public function DataClass():void{
			phpLoaderClass = new PHPLoaderClass();
			phpLoaderClass.addEventListener( ConstantClass.CHECK_QRKEY_COMPLETE, loadDataCompleteHandler );
			phpLoaderClass.addEventListener( ConstantClass.INSERT_DATA_COMPLETE, loadDataCompleteHandler );
			phpLoaderClass.addEventListener( ConstantClass.LOAD_DATA_COMPLETE, loadDataCompleteHandler );
		}
				
		//--handler--------------------------------------------------------------------------------------
		private function loadDataCompleteHandler( e:Event ):void{
//			trace("Load Data Complete!!!");
			if( e.type == ConstantClass.CHECK_QRKEY_COMPLETE ){
				dispatchEvent( new Event( ConstantClass.CHECK_QRKEY_COMPLETE, true ) );
			}else if( e.type == ConstantClass.INSERT_DATA_COMPLETE ){
				dispatchEvent( new Event( ConstantClass.INSERT_DATA_COMPLETE, true ) );
			}else if( e.type == ConstantClass.LOAD_DATA_COMPLETE ){
				dispatchEvent( new Event( ConstantClass.LOAD_DATA_COMPLETE, true ) );
			}
		}
		
		//--public function------------------------------------------------------------------------------
		public function searchFromDB( _vars:URLVariables ):void{
			phpLoaderClass.updatePhp( ConstantClass.PHP_FILE_PATH, _vars );
		}
		
		public function getQRKeyStatus():Boolean{
			return phpLoaderClass.getQRKeyStatus();
		}
		
		public function getInsertStatus():Boolean{
			return phpLoaderClass.getInsertStatus();
		}
		
		public function getDataArray():Array{
			return phpLoaderClass.getDataArray();
		}
	}
}
package com.yuco.registration_terminals_g1b4.db{
	
	public class ConstantClass{
		
		//use for dispatch
		public static var XML_LOAD_COMPLETE:String = "XML_LOAD_COMPLETE";
		public static var CHECK_QRKEY_COMPLETE:String = "CHECK_QRKEY_COMPLETE";			//check qr key status from database
		public static var INSERT_DATA_COMPLETE:String = "INSERT_DATA_COMPLETE";			//check qr key status from database
		public static var LOAD_DATA_COMPLETE:String = "LOAD_DATA_COMPLETE";				//load data from database
		
		//record by xml
		public static var HOST:String = "localhost";
		public static var USER_ID:String = "root";
		public static var PASSWORD:String = "lab123123";
		public static var HOST_SPARE:String = "";
		public static var USER_ID_SPARE:String = "";
		public static var PASSWORD_SPARE:String = "";
		public static var DB:String = "";
		public static var TABLE:String = "";
		public static var PHP_FILE_PATH:String = "";
		
//		public static const POPULARITY_RATIO:Array = new Array( 6, 6, 6, 6, 6 );
				
		public function ConstantClass():void{
		}
	}
}
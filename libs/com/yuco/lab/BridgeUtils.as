package com.yuco.lab
{
	public class BridgeUtils
	{
	public static function hexStringToNumber(hexStr:String):Number {
			if( hexStr.charAt(0) == "#" && hexStr.length > 7 ) {
				return Number("*"); // NaN;
			}
			if( hexStr.charAt(0) != "#" && hexStr.length > 6 ){
				return Number("*"); // NaN;
			}
			
			if( hexStr.charAt(0) == "#" ) {
				var newStr:String = hexStr.substr(1, hexStr.length);
			} else {
				var newStr:String = hexStr;
			}
			
			if( newStr.length < 6 ) {
				var z:String = "000000";
				// add zeros to the string to make it 6 characters long
				newStr = newStr + z.substr(0, z.length - newStr.length);
			}
			var numStr:String = "0x" + newStr;
			var num:Number = Number(numStr);
			return num;
		}
		//http://www.actionscript.org/forums/showthread.php3?t=189952
		public static function byte2bin(byte:uint):String {
			var bin:String = '';
			if(byte == 0)
				return String("0");
	
			for(var i:uint = 0; i < 8; i++) {
				bin += String((byte & (0x80 >> i)) >> (7 - i));
				}
				return bin; 
		}
		// modified by byte2bin to Boolean Array to determin the light / the dirction
		public static function byte2binarr(byte:uint):Array {
			var bin:Array = [];
			if(byte == 0)
				return bin;

			for(var i:uint = 0; i < 8; i++) {
				bin.push(Boolean((byte & (0x80 >> i)) >> (7 - i)));
				}
				return bin; 
		}
	}
}
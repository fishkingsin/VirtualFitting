package com.yuco.log {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getQualifiedClassName;
	import net.hires.debug.Logger;
	/*//
	 *Autor: Ivan
	 * Date: 2012-2-23
	
	Logger to Connect to the log server
	
	Functions:
	+ connect(_host:String, _port:int) // connect to the server
	
	//The following functions log the message at different levels
	//the provided className and functionName will overwrite the default
	+ Debug(_message:String, _functionName:String = "", _className:String = "")
	+ Info(_message:String, _functionName:String = "", _className:String = "")
	+ Warn(_message:String, _functionName:String = "", _className:String = "")
	+ Err(_message:String, _functionName:String = "", _className:String = "")
	
	+ SetClass(c:*) // set class name by a class object
	+ SendCMD(index:String) // send the command to the logger to run
	
	Variables:
	+ reconnectTime:int = 5000; // Time to check if connection is lost
	+ ClassName:String //default class name
	+ FunctionName:String //default function name
	+ TraceOutput:Boolean //trace the output in Flash, default is false
	
	//*/
	public class YucoLogger extends EventDispatcher {
		private var port:int;
		private var host:String;
		private var theSocket:Socket;
		private var reconnectTimer:Timer;
		
		public var reconnectTime:int = 5000; // Time to check if connection is lost
		public var ClassName:String;
		public var FunctionName:String;
		public var TraceOutput:Boolean;
		
		private var configLoader:URLLoader;
		private var logDebug:Boolean;
		private var logInfo:Boolean;
		private var logWarn:Boolean;
		private var logErr:Boolean;
		
		private var connectionFlag:Boolean; //indicate if connected or disconnected
		
		public function YucoLogger(_host:String = "127.0.0.1", _port:int = 9757) {
			ClassName = "DefaultClass";
			FunctionName = "DefaultFunction";
			
			configLoader = new URLLoader();
			configLoader.addEventListener(Event.COMPLETE, configLoaded);
			configLoader.addEventListener(IOErrorEvent.IO_ERROR, ConfigIOErrorHandler);
			configLoader.load(new URLRequest("log_config.xml"));
			
			theSocket = new Socket();
			theSocket.addEventListener(Event.CONNECT, onConnect);
			theSocket.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			
			logDebug = true;
			logInfo = true;
			logWarn = true;
			logErr = true;
			
			host = _host;
			port = _port;
			
			connectionFlag = false;
		}
		private function configLoaded(e:Event) {
			var xml:XML = new XML(configLoader.data);
			if (xml.log_debug=="false") {
				logDebug = false;
			}
			if (xml.log_info=="false") {
				logInfo = false;
			}
			if (xml.log_warn=="false") {
				logWarn = false;
			}
			if (xml.log_err=="false") {
				logErr = false;
			}
			connect(host, port);
		}
		private function reconnectTimerEvent(e:TimerEvent) {
			if (!theSocket.connected) {
				if (connectionFlag) {
					this.dispatchEvent(new Event("DISCONNECT"));
					connectionFlag = false;
				}
				theSocket.connect(host, port);
				//trace("Logger reconnecting...");
			}
		}
		private function onConnect(e:Event) {
			connectionFlag = true;
			this.dispatchEvent(new Event("CONNECT"));
			//trace("Logger connected!");
			//theSocket.removeEventListener(Event.CONNECT, onConnect);
		}
		public function SendCMD(_cmd:String) {
			send("$CMD" + _cmd+"$");
		}
		public function SetClass(c:*) {
			ClassName = getQualifiedClassName(c);
		}
		public function Debug(_message:String, _functionName:String = "", _className:String = "") {
			if (logDebug) {
				sendLog("DBG", _message, _functionName, _className);
			}
		}
		public function Info(_message:String, _functionName:String = "", _className:String = "") {
			if (logInfo) {
				sendLog("INF", _message, _functionName, _className);
			}
		}
		public function Warn(_message:String, _functionName:String = "", _className:String = "") {
			if (logWarn) {
				sendLog("WRN", _message, _functionName, _className);
			}
		}
		public function Err(_message:String, _functionName:String = "", _className:String = "") {
			if (logErr) {
				sendLog("ERR", _message, _functionName, _className);
			}
		}
		private function sendLog(_type:String, _message:String, _functionName:String = "", _className:String = "") {
			var classNameString:String = _className;
			var functionNameString:String = _functionName;
			var errString:String="";
			if (classNameString == "") {
				classNameString = ClassName;
			}
			if (functionNameString == "") {
				functionNameString = FunctionName;
			}
			if (functionNameString == "DefaultFunction" && classNameString == "DefaultClass") {
				//try auto generate class name and function name
				try {
					errString = new Error().getStackTrace();
					errString = errString.substr(10);
					var i:int = errString.indexOf("\n");
					i = errString.indexOf("\n", i + 1 );
					var j:int = errString.indexOf("\n", i + 1 );
					if (j == -1) {
						errString = errString.substring(i+5);
					}else {
						errString = errString.substring(i+5, j);
					}
					var k:int = errString.lastIndexOf("/");
					if (k != -1) {
						errString = errString.substring(0, k) +"->" + errString.substring(k + 1);
					}
					errString = errString.substring(0, errString.length - 2);
				}catch (e:Error) {
					//if Flash player is not debug version, use default class name and function name
					errString =  classNameString +"->" + functionNameString;
				}
			}else {
				errString =  classNameString +"->" + functionNameString;
			}
			if (errString != "") {
				send("["+_type+"]" + "[" + errString + ":"+_message+"]");
			}
		}
		private function send(_message:String) {
			if (TraceOutput) {
				trace(_message);
			}
			if(theSocket.connected){
				try{
					var ba:ByteArray = new ByteArray();
					ba.writeMultiByte(_message+"$n$", "utf-8");
					theSocket.writeBytes(ba);
					theSocket.flush();
					
				} catch (e:Error) {
					//trace("Logger Failed to send message");
				}
			}else {
				//trace("Logger Failed to send message. Please connect to the Logger Program.");
			}
		}
		public function connect(_host:String, _port:int) {
			if (reconnectTimer) {
				reconnectTimer.removeEventListener(TimerEvent.TIMER, reconnectTimerEvent);
				reconnectTimer.stop();
			}
			reconnectTimer = new Timer(reconnectTime);
			reconnectTimer.addEventListener(TimerEvent.TIMER, reconnectTimerEvent);
			
			host = _host;
			port = _port;
			try{
				theSocket.connect(host, port);
			}catch (e:Error) {
				//trace("Logger Socket failed to connect");
			}
			reconnectTimer.start();
		}
		private function IOErrorHandler(e:IOErrorEvent) {
			//trace("Logger Socket failed to connect");
		}
		private function ConfigIOErrorHandler(e:IOErrorEvent) {
			//default no config
			connect(host, port);
		}
		public static function getFunctionName(e:Error):String
		{
			
			/*try{
				var stackTrace:String = e.getStackTrace();// entire stack trace
				var startIndex:int = stackTrace.indexOf("at ");// start of first line
				var endIndex:int = stackTrace.indexOf("()");// end of function name
				return stackTrace.substring(startIndex + 3, endIndex);
			}
			catch(error:Error)
			{
				Logger.debug(error.message);
			}*/
			return "";
		}
	}
	
}
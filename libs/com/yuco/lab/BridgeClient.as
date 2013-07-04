package com.yuco.lab
{
	import flash.events.*;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.*;
	import flash.system.*;
	public class BridgeClient extends EventDispatcher
	{

		var port:int = 2838;
		var host:String = "localhost";
		var socket:Socket;
		private var reconnectInterval:int;
		private var gcInterval:int;
		public var server_status:String;
		public var _arr:Array = new Array  ;
		private var _buffer:ByteArray = new ByteArray();
		public function get buffer():ByteArray
		{
			return _buffer;
		}
		public function BridgeClient(_host:String , _port:int)
		{
			// constructor code
			host = _host;
			port = _port;
			socket = new Socket(host,port);
			configureListener(socket);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
			_arr.push([false,false,false,false,false,false,false,false]);
		}
		public function sendString(string:String):void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(string);
			this.sendByte(ba);
		}
		public function sendArray(arr:Array):void
		{
			var ba:ByteArray = new ByteArray();
			for (var i:int = 0; i < arr.length; i++)
			{
				if (arr[i].length == 8)
				{
					ba[i] = 
					int(arr[i][0])|
					int(arr[i][1]) << 1 |
					int(arr[i][2]) << 2 |
					int(arr[i][3]) << 3 |
					int(arr[i][4]) << 4 |
					int(arr[i][5]) << 5 |
					int(arr[i][6]) << 6 |
					int(arr[i][7]) << 7 ;
				}
			}
			sendByte(ba);
		}

		public function sendByte(ba:ByteArray):void
		{
			try
			{
				socket.writeBytes(ba);
				socket.flush();
			}
			catch (error:Error)
			{
				dispatchEvent(new BridgeEvent(BridgeEvent.ERROR,"Bridge Status :"+String(error.message)));
			}
		}

		public function reconnect():void
		{
			try
			{
				socket.close();
				socket.flush();
				socket.connect(host,port);
				//trace("socket.connect("+host+","+port+");");
			}
			catch (error:Error)
			{
				dispatchEvent(new BridgeEvent(BridgeEvent.ERROR,String(error.message)));
			}
		}
		private var gcCount:int;
		private function startGCCycle():void
		{
			gcCount = 0;
			//addEventListener(Event., doGC);
			gcInterval = setInterval(doGC,100);
		}
		private function doGC():void
		{
			System.gc();
			if (++gcCount > 1)
			{
				clearInterval(gcInterval);
				//removeEventListener(Event.ENTER_FRAME, doGC);
				setTimeout(lastGC, 40);
			}
		}
		private function lastGC():void
		{
			System.gc();
		}

		private function socketData(e:ProgressEvent):void
		{
			//here we go to prase the data to  Bollean array
			var _socket:Socket = e.target as Socket;
			_buffer.clear();
			//we get byte array from server buffer.length represent the port number;
			_socket.readBytes(_buffer, _buffer.length);
			//we have two type of model 
			//8 channels and 128 channels
			//8 channel handle 1 byte each time so the buffer length =1 
			//128 channel handle 16 byte each time so the buffer length =16 
			//each byte have 8 bit if we use 1 channel , we will have 8 I/O
			//the boolean array would be somthing like[true,false,true,false,true,false,true,false]
			//in 128 channels [true,false,true,false,true,false,true,false] x 16
			// and also this example tace out the boolean array and binary string for clear explanation 
			if (buffer.length <= 16)
			{
/*trace(Number(buffer[0]));
				
				for (var x:int = 0; x <1 ; x++){
					//if(x<tf_arr.length)tf_arr[x].text =  byte2bin(buffer[x]);
					if(buffer[x]>0)trace("index "+x+"= "+byte2binarr(buffer[x]));
				}
				
			}
			else if( buffer.length==2)
			{
				
				for (var x:int = 0; x <2 ; x++)
				{
					//if(x<tf_arr.length)tf_arr[x].text =  byte2bin(buffer[x]);
					if(buffer[x]>0)trace("index "+x+"= "+byte2binarr(buffer[x]));
				}
				
			}
			else if( buffer.length==16)
			{
				for (var x:int = 0; x <16 ; x++)
				{
					
					//if(x<tf_arr.length)
					{
						//tf_arr[x].text =  byte2bin(buffer[x]);
						if(buffer[x]>0)trace("index "+x+"= "+byte2binarr(buffer[x]));
					}
				}*/


				for (var i:int = 0; i < buffer.length; i++)
				{

					_arr[i][0] = Boolean((buffer[i] & (0x80 >> 0)) >> 7);
					_arr[i][1] = Boolean((buffer[i] & (0x80 >> 1)) >> 6);
					_arr[i][2] = Boolean((buffer[i] & (0x80 >> 2)) >> 5);
					_arr[i][3] = Boolean((buffer[i] & (0x80 >> 3)) >> 4);
					_arr[i][4] = Boolean((buffer[i] & (0x80 >> 4)) >> 3);
					_arr[i][5] = Boolean((buffer[i] & (0x80 >> 5)) >> 2);
					_arr[i][6] = Boolean((buffer[i] & (0x80 >> 6)) >> 1);
					_arr[i][7] = Boolean((buffer[i] & (0x80 >> 7)) >> 0);
				}
				dispatchEvent(new BridgeDataEvent(BridgeDataEvent.BRIDGE_DATA,_arr));

			}
			else
			{
				//some time the servwer would send you some message and it would be larger than 16 byte
				//server_status = String(buffer);
				dispatchEvent(new BridgeEvent(BridgeEvent.BRIDGE_STATUS,String(_buffer)));
			}

			startGCCycle();
			socket.flush();


		}

		private function configureListener(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(Event.CLOSE,closeHandler);
			dispatcher.addEventListener(Event.CONNECT,connectHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			dispatcher.addEventListener(ProgressEvent.SOCKET_DATA, socketData);

		}
		private function connectHandler(e:Event):void
		{
			dispatchEvent(new BridgeEvent(BridgeEvent.CONNECT,"Connected to Host: "+host+" Port: "+port));

		}

		private function closeHandler(e:Event):void
		{
			dispatchEvent(new BridgeEvent(BridgeEvent.CLOSE,"Close from Host: "+host+" Port: "+port));

			reconnectInterval = setInterval(reconnectHandler,5000);
		}

		private function ioErrorHandler(e:IOErrorEvent):void
		{
			dispatchEvent(new BridgeEvent(BridgeEvent.ERROR,"ioErrorHandler Host: "+host+" Port: "+port));
			reconnectInterval = setInterval(reconnectHandler,5000);
		}

		private function reconnectHandler():void
		{
			//dispatchEvent(new BridgeEvent(BridgeEvent.RECONNECT,"Reconnect to Host: "+host+" Port: "+port));
			//trace("reconnectHandler");
			clearInterval(reconnectInterval);
			try
			{
				socket.connect(host,port);
			}
			catch (error:Error)
			{
				dispatchEvent(new BridgeEvent(BridgeEvent.ERROR,"reconnectHandler: Reconnect to Host: "+host+" Port: "+port));
			}

		}
	}


}
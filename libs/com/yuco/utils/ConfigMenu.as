package com.yuco.utils
{
	import flash.events.*;
	import flash.utils.*;
	import flash.net.*;
	import flash.display.*;
	import flash.display.*;
	import flash.ui.*;
	import flash.text.*;
	public class ConfigMenu extends Sprite
	{
		static const CONFIRM:String = "CONFIRM";
		static const SAVE:String = "SAVE";
		static const APPLY:String = "APPLY";
		static const CANCEL:String = "CANCEL";
		
		//[Embed(source = "./assets/Gotham-Medium_0.ttf",fontFamily = "Gotham-Medium")]
		//public var f1:String;	
		
		//private var urlVar:Array = [];
		private var format1:TextFormat;
		private var ty:int = 3;
		private var _confirm:TextField;
		private var _apply:TextField;
		private var _cancel:TextField;
		private var _save:TextField;

		private var confirm:SimpleButton;
		private var apply:SimpleButton;
		private var cancel:SimpleButton;
		private var save:SimpleButton;
		private static var stack : Dictionary = new Dictionary(); 
		private var dw:Number;
		public function ConfigMenu()
		{
			// constructor code
			format1 = new TextFormat();
			//var font1:Font1=new Font1();
			format1.font = "LiHei Pro";

			format1.color = 0x000000;
			format1.size = 24;
			format1.align = TextFormatAlign.LEFT;

			createButtons();
			confirm.addEventListener(MouseEvent.CLICK,function onClick(e:Event):void{
			 	parent.removeChild(e.target.parent);
				dispatchEvent( new Event( CONFIRM, true ) );
			 });
			apply.addEventListener(MouseEvent.CLICK,function onClick(e:Event):void{
					
				dispatchEvent( new Event( APPLY, true ) );
			 });
			cancel.addEventListener(MouseEvent.CLICK,function onClick(e:Event):void{
			 	parent.removeChild(e.target.parent);
				dispatchEvent( new Event( CANCEL, true ) );
				
			 });
			save.addEventListener(MouseEvent.CLICK,function onClick(e:Event):void{
			 	dispatchEvent( new Event( SAVE, true ) );
				
			/*try{
				var file:File = File.applicationDirectory.resolvePath("./data/config.txt");
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.WRITE);
				stream.writeUTFBytes("This is my text file.");
				stream.close();
			}catch(error:Error){
				trace(error.message);
			}*/
			 });
			 addEventListener(MouseEvent.MOUSE_DOWN,function mousedown(e:MouseEvent)
							  {
								  startDrag();
							  });
			 addEventListener(MouseEvent.MOUSE_UP,function mouseup(e:MouseEvent)
							  {
								 stopDrag();
							  });
							  				

		}
		private function createButtons():void
		{

			_cancel = createTextField();
			_apply = createTextField();
			_confirm = createTextField();
			_save = createTextField();
			confirm = createButton(_confirm);
			apply = createButton(_apply);
			cancel = createButton(_cancel);

			save = createButton(_save);

			_confirm.background = true;
			_confirm.backgroundColor = 0x999999;
			_confirm.text = "Confirm";

			_apply.background = true;
			_apply.backgroundColor = 0x999999;
			_apply.text = "Apply";

			_cancel.background = true;
			_cancel.backgroundColor = 0x999999;
			_cancel.text = "Cancel";
			_save.background = true;
			_save.backgroundColor = 0x999999;
			_save.text = "Save";

			confirm.x = 10;
			apply.x = confirm.x + confirm.width + 10;
			cancel.x = apply.x + apply.width + 10;
			save.x = cancel.x + cancel.width + 10;
			addChild(confirm);
			addChild(apply);
			addChild(cancel);
			addChild(save);
		}
		private function createButton(_tf:TextField):SimpleButton
		{
			var mc = new Sprite();
			mc.addChild(_tf);
			var _button = new SimpleButton(mc,mc,mc,mc);
			return _button;
		}
		private function createTextField():TextField
		{
			var tf:TextField = new TextField();
			tf.antiAliasType = AntiAliasType.ADVANCED;
			//tf.embedFonts = true;
			tf.autoSize = TextFieldAutoSize.LEFT;
			//tf.name = n;
			tf.mouseEnabled = false;
			tf.defaultTextFormat = format1;
			return tf;
		}
		public function addVariable(n:String , v:*)
		{
			var tf1:TextField = createTextField();
			tf1.text = n + " \t:\t ";
			tf1.y = ty;
			//tf1.y = this.height/2-tf1.height/2;
			addChild(tf1);

			var tf2:TextField = createTextField();
			tf2.type = TextFieldType.INPUT;
			tf2.background = true;
			tf2.mouseEnabled = true;
			tf2.text = v;//.toString();
			tf2.y = ty;
			tf2.x = tf1.x + tf1.width;
			dw = (dw>tf2.x+tf2.width)?dw:tf2.x+tf2.width;
			addChild(tf2);

			ty = tf1.y ;//+ tf1.height;
			stack[n] = tf2;
			save.y = cancel.y = apply.y = confirm.y = ty + 3+tf1.height;
			ty = cancel.y ;

			
			graphics.clear();
			graphics.lineStyle(3,0x000000);
			graphics.beginFill(0xAAAAAA,0.5);
			graphics.drawRect(0,0,dw,ty+3+cancel.height);
			graphics.endFill();

		}
		public function value(n:String):*
		{
			/*for (var i:int = 0; i < stack.length; i++)
			{
				if (stack[i][0] == n)
				{*/
				return stack[n].text.valueOf();
					//return stack[i][1];
				/*}
			}*/
			//return 0;
		}

	}

}
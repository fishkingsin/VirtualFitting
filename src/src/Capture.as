﻿package 
			addEventListener(Event.ENTER_FRAME,function _onEnterFrame(e:Event)
			{
				var now:Date = new Date();
				var timestamp:String = now.valueOf().toString();
				removeEventListener(Event.ENTER_FRAME,_onEnterFrame);
			});
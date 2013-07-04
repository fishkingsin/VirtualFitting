package 
{
	import gs.TweenMax;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class customDropDownList extends Sprite
	{
		private var isDropped:Boolean = false;

		public function customDropDownList()
		{
			super();
			mouseEnabled = false;

			addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
		}
		private function addedToStage(e:Event)
		{
			//trace("customDropDownList: addToStage");
			for (var i:int = numChildren - 1; i>=0; i--)
			{
				var mc = getChildAt(i);

				if (i==numChildren - 1)
				{
					mc.addEventListener(SmoothingBitmapLoader.INIT,onComplete);

					mc.addEventListener(MouseEvent.MOUSE_DOWN,onMouseClicked);
				}
			}
		}
		private function onMouseClicked(e:Event):void
		{
			trace("mc " ,e.target.name);
			isDropped = true;
			trace(name+ " isDropped "+isDropped);
			onClick();
			//mc.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseClicked);
		}
		private function onComplete(e:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function removeFromStage(e:Event)
		{
			//trace("customDropDownList: addToStage");
			for (var i:int = numChildren - 1; i>=0; i--)
			{
				var mc = getChildAt(i);

				if (i==numChildren - 1)
				{
					mc.removeEventListener(SmoothingBitmapLoader.INIT,onComplete);

					mc.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseClicked);
				}
			}
		}




		private function onClick():void
		{



			var oldY:int = 0;
			for (var i:int = numChildren - 1; i>=0; i--)
			{
				var mc = getChildAt(i);
				//trace("mc.x "+mc.x+"mc.y "+mc.y+"mc.height "+mc.height);
				if (isDropped)
				{
					//trace(i+ " open");
					dispatchEvent(new Event("open"));
					TweenMax.to(mc,1,{y:oldY,onUpdateListener:onUpdate});
					oldY +=  mc.height;
					trace(i+ " oldY" + oldY);
					trace(i+ " mc.height "+ mc.height);
				}
				/*else
				{
					TweenMax.to(mc,1,{y:0,onUpdateListener:onUpdate});
				}*/
			}
		}
		public function close():void
		{
			isDropped = false;

			for (var i:int = numChildren - 1; i>=0; i--)
			{
				var mc = getChildAt(i);

				TweenMax.to(mc,1,{y:0,onUpdateListener:onUpdate});

			}
		}
		private function onUpdate(arg:*):void
		{
			dispatchEvent(new Event("list_update"));
			/*for (var i:int = numChildren - 1; i>=0; i--)
			{
				var mc = getChildAt(i);

				trace(i+ " mc.y " + mc.y);

			}*/
		}
	}

}
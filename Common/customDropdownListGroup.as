package 
{
	import gs.TweenMax;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class customDropdownListGroup extends Sprite
	{

		public function customDropdownListGroup()
		{
			super();
			mouseEnabled = false;

			// constructor code
			addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);

		}
		private function addedToStage(e:Event)
		{
			//trace("customDropdownListGroup: addToStage");
			var oldY:int = 0;
			for (var i:int=0; i < numChildren; i++)
			{
				
				var mc = getChildAt(i);
				//trace("mc.x "+mc.x+"mc.y "+mc.y);
				mc.x = 0;
				mc.y = oldY;
				oldY +=  mc.height;
				mc.addEventListener(Event.COMPLETE,onComplete);
				mc.addEventListener("open",onOpen);
				mc.addEventListener("list_update",onUpdate);
			}
		}
		private function removeFromStage(e:Event)
		{
			for (var i:int=0; i < numChildren; i++)
			{
				var mc = getChildAt(i);
				mc.removeEventListener(Event.COMPLETE,onComplete);
				mc.removeEventListener("open",onOpen);
				mc.removeEventListener("list_update",onUpdate);
				mc.close();
			}
		}
		function onComplete(e:Event)
		{

			var index = getChildIndex(e.target as Sprite);
			if (index>0)
			{
				var mc = getChildAt(index-1);

				//trace("customDropdownListGroup: onComplete  mc.y "+ mc.y+" mc.height "+mc.height);
				e.target.y = mc.y + mc.height;
			}
		}
		function onOpen(e:Event)
		{

			var index = getChildIndex(e.target as Sprite);
			//trace("customDropdownListGroup: onComplete  index = "+index);
			for (var i:int = 0; i<numChildren; i++)
			{

				var mc1 = getChildAt(i);
				if (mc1!=e.currentTarget)
				{
					mc1.close();
					//trace("mc1.close");
				}

			}
		}
		function onUpdate(e:Event)
		{

			for (var i:int = 0; i<numChildren-1; i++)
			{
				var mc2 = getChildAt(i+1);
				var mc1 = getChildAt(i);
				mc2.y = mc1.y + mc1.height;
				//trace("mc2.y "+mc2.y+" mc1.y : "+mc1.y+" mc1.height : "+mc1.height);
			}
		}
	}

}
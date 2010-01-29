package com.flexsqladmin.sqladmin.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.components.DebugWindow;

	public class InitEvent extends CairngormEvent
	{
		public static var INITEVENT:String = "initevent";
		
		public function InitEvent()
		{
			DebugWindow.log("InitEvent.as:InitEvent()");
			super(INITEVENT);
		}
	}
}
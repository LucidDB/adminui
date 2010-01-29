package com.flexsqladmin.sqladmin.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	
	public class MetaDataEvent extends CairngormEvent
	{
		
		public static var METADATA:String = "metadata";
		
		public function MetaDataEvent()
		{
			DebugWindow.log("MetaDataEvent.as:MetaDataEvent()");
			super(METADATA);
		}
		
	}
}
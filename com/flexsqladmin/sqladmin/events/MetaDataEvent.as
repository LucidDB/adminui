package com.flexsqladmin.sqladmin.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	
	public class MetaDataEvent extends CairngormEvent
	{
		
		public static var METADATA:String = "metadata";
		public var catalog_name:String = "LOCALDB"
		public function MetaDataEvent(s:String)
		{
			DebugWindow.log("MetaDataEvent.as:MetaDataEvent('"+catalog_name+"')");
			catalog_name = s;
			super(METADATA);
		}
		
	}
}
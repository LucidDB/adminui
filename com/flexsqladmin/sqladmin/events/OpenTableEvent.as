package com.flexsqladmin.sqladmin.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import mx.controls.DataGrid;

	public class OpenTableEvent extends CairngormEvent
	{
		public var table:String = "";
		public var tabledatagrid:DataGrid;
		
		public static var OPENTABLE:String = "openTable";
		
		public function OpenTableEvent(t:String, dg:DataGrid)
		{
			DebugWindow.log("OpenTableEvent.as:OpenTableEvent('" + t + "')");
			super(OPENTABLE);
			table = t; 
			tabledatagrid = dg;
		}
	}
}
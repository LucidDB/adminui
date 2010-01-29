package com.flexsqladmin.sqladmin.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.vo.OpenTableData;
	import mx.controls.DataGrid;
	import com.flexsqladmin.sqladmin.view.OpenTableWindow;
	import mx.events.DataGridEvent;

	public class UpdateDataEvent extends CairngormEvent
	{
		public var tablemetadata:OpenTableData;
		public var datagrid:DataGrid;
		public var tablewindow:OpenTableWindow;
		public var itemevent:DataGridEvent;
		
		public static var UPDATEDATA:String = "updateData";
		
		public function UpdateDataEvent(tablemd:OpenTableData, dg:DataGrid, window:OpenTableWindow, event:DataGridEvent)
		{
			DebugWindow.log("UpdateDataEvent.as:UpdateDataEvent('" + tablemd.getTable() + "')");
			super(UPDATEDATA);
			tablemetadata = tablemd;
			datagrid = dg;
			tablewindow = window;
			itemevent = event;
		}
	}
}
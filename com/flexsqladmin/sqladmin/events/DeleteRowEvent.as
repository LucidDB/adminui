package com.flexsqladmin.sqladmin.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.vo.OpenTableData;
	import mx.controls.DataGrid;
	import com.flexsqladmin.sqladmin.view.OpenTableWindow;

	public class DeleteRowEvent extends CairngormEvent
	{
		public var tablemetadata:OpenTableData;
		public var datagrid:DataGrid;
		public var tablewindow:OpenTableWindow;
		
		public static var DELETEROW:String = "deleteRow";
		
		public function DeleteRowEvent(tablemd:OpenTableData, dg:DataGrid, window:OpenTableWindow)
		{
			DebugWindow.log("DeleteRowEvent.as:DeleteRowEvent('" + tablemd.getTable() + "')");
			super(DELETEROW);
			tablemetadata = tablemd;
			datagrid = dg;
			tablewindow = window;
		}
	}
}
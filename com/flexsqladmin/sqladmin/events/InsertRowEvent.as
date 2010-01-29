package com.flexsqladmin.sqladmin.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.vo.OpenTableData;
	import com.flexsqladmin.sqladmin.view.InsertRowWindow;

	public class InsertRowEvent extends CairngormEvent
	{
		public var tablemetadata:OpenTableData;
		public var insertrowwindow:InsertRowWindow;
		
		public static var INSERTROW:String = "insertRow";
		
		public function InsertRowEvent(tablemd:OpenTableData, window:InsertRowWindow)
		{
			DebugWindow.log("InsertRowEvent.as:InsertRowEvent('" + tablemd.getTable() + "')");
			super(INSERTROW);
			tablemetadata = tablemd;
			insertrowwindow = window;
		}
	}
}
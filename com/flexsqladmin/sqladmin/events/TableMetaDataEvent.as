package com.flexsqladmin.sqladmin.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.vo.OpenTableData;

	public class TableMetaDataEvent extends CairngormEvent
	{
		public var tablemetadata:OpenTableData;
		
		public static var TABLEMETADATA:String = "tableMetaData";
		
		public function TableMetaDataEvent(tablemd:OpenTableData)
		{
			DebugWindow.log("TableMetaDataEvent.as:TableMetaDataEvent('" + tablemd.getTable() + "')");
			super(TABLEMETADATA);
			tablemetadata = tablemd;
		}
	}
}
package com.flexsqladmin.sqladmin.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	
	import mx.controls.DataGrid;
	
	public class ExecuteSQLEvent extends CairngormEvent
	{
		public var sql:String = "";
		public var sqlquerytype:String = "";
		public var querydatagrid:DataGrid;
        public var func:Function;
		
		public static var EXECUTESQL:String = "executeSQL";
		
		public function ExecuteSQLEvent(s:String, sqt:String, func:Function=null)
		{
			DebugWindow.log("ExecuteSQLEvent.as:ExecuteSQLEvent('" + s + "', '" + sqt + "')");
			super(EXECUTESQL);
			sql = s; 
			sqlquerytype = sqt;
            this.func = func;
		}
	}
}
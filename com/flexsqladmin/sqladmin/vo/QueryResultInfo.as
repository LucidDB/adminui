package com.flexsqladmin.sqladmin.vo
{
	[Bindable]
	public class QueryResultInfo {
		import mx.collections.XMLListCollection;
		import com.flexsqladmin.sqladmin.components.ExecutionPlanWindow;
		import mx.controls.DataGrid;

		public var querydata:XMLListCollection;
		public var querymessages:String;
		public var queryHistoryVO:QueryHistoryVO;
		public var showplanwindow:ExecutionPlanWindow;
		public var querydatagrid:DataGrid;
	}
}
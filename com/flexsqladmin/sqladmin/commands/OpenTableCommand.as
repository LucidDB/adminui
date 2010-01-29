package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.business.Responder;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.events.OpenTableEvent;
	import com.flexsqladmin.sqladmin.business.execSQLDelegate;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.collections.XMLListCollection;

	public class OpenTableCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		private var tabledatagrid:DataGrid;
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("OpenTableCommand.as:execute()");
			var table:String = OpenTableEvent(event).table;
			tabledatagrid = OpenTableEvent(event).tabledatagrid;
			var delegate:execSQLDelegate = new execSQLDelegate(this);
			delegate.execSQL("SELECT * FROM [" + table + "]", "normal", model.connectionVO);
		}
		
		public function onResult(event:*=null):void
		{
			DebugWindow.log("OpenTableCommand.as:onResult()");
			DebugWindow.log("OpenTable Data\n" + event.result.toString());
			var cols:Array = new Array();
            var dgcols:Array = new Array();

			//getTableMetaData();
            var tablexml:XML = new XML(event.result);
            var tabledata:XMLListCollection = new XMLListCollection(tablexml.NewDataSet.Table);
            cols = tablexml.datamap.split(",");
            for(var k:int;k < cols.length;k++){
                var dgcolumn:DataGridColumn = new DataGridColumn(cols[k]);
                dgcolumn.dataTipField = cols[k];
                dgcolumn.dataField = cols[k];
                if(tablexml.edittable == "false")
                	dgcolumn.editable = false;
                dgcols.push(dgcolumn);
            }
            tabledatagrid.dataProvider = tabledata
            tabledatagrid.columns = dgcols;
		}
		
		public function onFault(event:*=null):void
		{
			DebugWindow.log("OpenTableCommand.as:onFault()");
		}
		
	}
}
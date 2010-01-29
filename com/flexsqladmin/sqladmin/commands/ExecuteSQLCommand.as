package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.business.Responder;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.events.ExecuteSQLEvent;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flexsqladmin.sqladmin.business.execSQLDelegate;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import mx.collections.XMLListCollection;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.controls.DataGrid;
	
	public class ExecuteSQLCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		private var sqlquerytype:String = "";
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("ExecuteSQLCommand:execute()");
			model.exectimer.startTimer();
			var sql:String = ExecuteSQLEvent(event).sql;
			sqlquerytype = ExecuteSQLEvent(event).sqlquerytype;
			var delegate:execSQLDelegate = new execSQLDelegate(this);
			delegate.execSQL(sql, sqlquerytype, model.tempConnectionVO);
			model.queryHistoryVO.writeHistory(sql, sqlquerytype);
		}
		public function onResult(event:*=null):void
		{
			DebugWindow.log("ExecuteSQLCommand.as:onResult()");
			DebugWindow.log("Web Service Result\n" + event.result.toString());
			
			model.exectimer.stopTimer();
			model.showplanwindow.clearWindow();
			
			var querycols:Array = new Array();
           	var datagridcols:Array = new Array();
			
			var queryxml:XML = new XML(event.result);
			model.querydata = new XMLListCollection(queryxml.NewDataSet.Table);
			 
			if(sqlquerytype != "showplan")
                querycols = queryxml.datamap.split(",");
                
            for(var x:int; x < querycols.length; x++){
                var querycolumn:DataGridColumn = new DataGridColumn(querycols[x]);
                querycolumn.dataTipField = querycols[x];
                querycolumn.dataField = querycols[x];
               	querycolumn.editable = false;
                datagridcols.push(querycolumn);
            }
            
            model.querydatagrid.columns = datagridcols;
			
			if(queryxml.recordcount != ''){
                model.querymessages = queryxml.recordcount + " row(s) returned.  Execution time: " + queryxml.executiontime + " ms";
            } else {
                model.querymessages = "";
            } 
            
            if((sqlquerytype == "showplan" || sqlquerytype == "spnormal") && queryxml.datamap.toString() != "Error"){
            	model.showplanwindow.drawPlan(queryxml);
            }
            //resetSelection();
		}
		public function onFault(event:*=null):void
		{
			DebugWindow.log("ExecuteSQLCommand.as:onFault()");
		}
	}
}
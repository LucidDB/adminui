package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flexsqladmin.sqladmin.business.GeneralDelegate;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.events.ExecuteSQLEvent;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.vo.QueryResultInfo;
	
	import mx.collections.XMLListCollection;
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	
	public class ExecuteSQLCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
        private var sql:String = "";
		private var sqlquerytype:String = "";
        private var func:Function;
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("ExecuteSQLCommand:execute()");
			model.exectimer.startTimer();
			sql = ExecuteSQLEvent(event).sql;
			sqlquerytype = ExecuteSQLEvent(event).sqlquerytype;
            func = ExecuteSQLEvent(event).func;
            var delegate:GeneralDelegate = new GeneralDelegate(this, "sqlWebService");
            var args:Object = {connection: model.connectionVO.getConnectionString(),
                sqlquerytype: sqlquerytype,
                sql: sql,
                toomany: model.connectionVO.toomany
            };
            delegate.serviceDelegate("execSQL", args);
		}
		
		public function onResult(event:*=null):void
		{
			DebugWindow.log("ExecuteSQLCommand.as:onResult()");
			//DebugWindow.log("Web Service Result\n" + event.result.toString());
			model.exectimer.stopTimer();
			
			var querycols:Array = new Array();
           	var datagridcols:Array = new Array();
			
            try {
                model.query_results[VBox(model.main_tabnav.selectedChild).id].queryHistoryVO.writeHistory(sql, sqlquerytype);
            } catch(error:Error) {
                // make it default query window if it failed above
                model.main_tabnav.selectedIndex = model.main_tabnav.getChildIndex(model.main_tabnav.getChildByName("qw-1"));
                model.query_results[VBox(model.main_tabnav.selectedChild).id].queryHistoryVO.writeHistory(sql, sqlquerytype);
            }
            
            var result_info : QueryResultInfo = model.query_results[VBox(model.main_tabnav.selectedChild).id];
            result_info.showplanwindow.clearWindow();
            
            var rows:Number = 0;
            var executiontime:Number = 0;
            result_info.querydata = new XMLListCollection();
            
            var queries:XMLList = new XMLList(event.result);
            for each (var queryxml:XML in queries) {
                if (sqlquerytype == "special") {
                    func(queryxml);
                    continue;
                }
                
                trace(queryxml.toXMLString());
                trace();
                trace(queryxml.NewDataSet.Table.toXMLString());
                result_info.querydata = new XMLListCollection(queryxml.NewDataSet.Table);
                trace('...');
                //result_info.querydata += new XMLListCollection(queryxml.NewDataSet.Table);
                //result_info.querydata.addItem(new XML('<Table>' + queryxml.NewDataSet.Table.children() + '</Table>'));
                
                if(sqlquerytype != "showplan")
                    querycols = queryxml.datamap.split(",");
                
                for(var x:int = 0; x < querycols.length; x++){
                    var querycolumn:DataGridColumn = new DataGridColumn(querycols[x]);
                    querycolumn.dataTipField = querycols[x];
                    querycolumn.dataField = querycols[x];
                    querycolumn.editable = false;
                    datagridcols.push(querycolumn);
                }
                
                if(queryxml.recordcount != ''){
                    rows += Number(queryxml.recordcount);
                    executiontime += Number(queryxml.executiontime);
                } 
                
                DebugWindow.log("messages: " + result_info.querymessages);
                if((sqlquerytype == "showplan" || sqlquerytype == "spnormal") && queryxml.datamap.toString() != "Error"){
                    result_info.showplanwindow.drawPlan(queryxml);
                }
            }
            if (sqlquerytype == 'special')
                return;
            
            if (rows > 0) {
                result_info.querymessages = rows + " row(s) returned.  Execution time: " + executiontime + " ms";
            } else {
                result_info.querymessages = "";
            }
            result_info.querydatagrid.columns = datagridcols;
            //resetSelection();
		}
		public function onFault(event:*=null):void
		{
			DebugWindow.log("ExecuteSQLCommand.as:onFault()");
		}
	}
}
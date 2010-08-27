/*
Copyright 2006-2010 Kevin Kazmierczak. All rights reserved.
Copyright 2010 Dynamo Business Intelligence Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY Dynamo Business Intelligence Corporation ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Dynamo Business Intelligence Corporation OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flexsqladmin.sqladmin.business.GeneralDelegate;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.components.QueryWindow;
	import com.flexsqladmin.sqladmin.events.ExecuteSQLEvent;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.vo.QueryResultInfo;
	
	import mx.collections.XMLListCollection;
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.FlexGlobals;
	
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
			
            var result_info:QueryResultInfo;
            try {
                result_info = model.tabs[ VBox(model.main_tabnav.selectedChild).id.split('-')[0] ][VBox(model.main_tabnav.selectedChild).id].result_info;
            } catch(error:Error) {
                // write to default window
                result_info = model.tabs[String(QueryWindow)][String(QueryWindow) + '-1'].result_info;
            }
            result_info.queryHistoryVO.writeHistory(sql, sqlquerytype);
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
                
                result_info.querydata = new XMLListCollection(queryxml.NewDataSet.Table);
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
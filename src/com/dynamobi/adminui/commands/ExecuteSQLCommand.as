/*
Dynamo Admin UI is a web service project for administering LucidDB
Copyright (C) 2010 Dynamo Business Intelligence Corporation

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option)
any later version approved by Dynamo Business Intelligence Corporation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/
package com.dynamobi.adminui.commands
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.dynamobi.adminui.business.GeneralDelegate;
	import com.dynamobi.adminui.components.DebugWindow;
	import com.dynamobi.adminui.components.QueryWindow;
	import com.dynamobi.adminui.events.ExecuteSQLEvent;
	import com.dynamobi.adminui.model.ModelLocator;
	import com.dynamobi.adminui.vo.QueryResultInfo;
	
	import mx.collections.XMLListCollection;
	import mx.containers.VBox;
    import mx.controls.AdvancedDataGrid;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
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
            if (sqlquerytype == 'showplan')
                result_info.showplanwindow.clearWindow();
            
            var rows:Number = 0;
            var executiontime:Number = 0;
            if (sqlquerytype != 'showplan')
                result_info.querydata = new XMLListCollection();
            
            var queries:XMLList = new XMLList(event.result);
            for each (var queryxml:XML in queries) {
                if (sqlquerytype == "special") {
                    func(queryxml);
                    continue;
                }
                
                if (sqlquerytype != 'showplan')
                    result_info.querydata = new XMLListCollection(queryxml.NewDataSet.Table);
                //result_info.querydata += new XMLListCollection(queryxml.NewDataSet.Table);
                //result_info.querydata.addItem(new XML('<Table>' + queryxml.NewDataSet.Table.children() + '</Table>'));
                
                if(sqlquerytype != "showplan")
                    querycols = queryxml.datamap.split(",");
                
                for(var x:int = 0; x < querycols.length; x++){
                    var querycolumn:AdvancedDataGridColumn = new AdvancedDataGridColumn(
                        querycols[x].replace('ﾠ', ' '));
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
            if (sqlquerytype != 'showplan')
                result_info.querydatagrid.columns = datagridcols;
            //resetSelection();
		}
		public function onFault(event:*=null):void
		{
			DebugWindow.log("ExecuteSQLCommand.as:onFault()");
		}
	}
}
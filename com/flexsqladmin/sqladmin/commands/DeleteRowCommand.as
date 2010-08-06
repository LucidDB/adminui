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
	import com.flexsqladmin.sqladmin.business.GeneralDelegate;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.events.DeleteRowEvent;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.view.OpenTableWindow;
	import com.flexsqladmin.sqladmin.vo.OpenTableData;
	
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.DataGrid;

	public class DeleteRowCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		private var tablemetadata:OpenTableData;
		private var deletesql:String;
		private var datagrid:DataGrid;
		private var tablewindow:OpenTableWindow;
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("DeleteRowCommand.as:execute()");
			var deletestring:String = "";
			var checksqlstring:String = "";
			tablemetadata = DeleteRowEvent(event).tablemetadata;
			datagrid = DeleteRowEvent(event).datagrid;
			tablewindow = DeleteRowEvent(event).tablewindow;
			
			for (var x:int = 0; x < datagrid.selectedItem.children().length(); x++){
            	deletestring += "\"" + datagrid.columns[x].dataField + "\"";
            	if (datagrid.selectedItem.children()[x] == "<NULL>" || datagrid.selectedItem.children()[x].toString().toLowerCase() == 'null') {
            		deletestring += " IS NULL";
            	} else if(tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "MONEY" || tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "SMALLMONEY"){
            		deletestring += " = " + datagrid.selectedItem.children()[x];
            	}else if(tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "INTEGER"|| tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "BOOLEAN"){
            		deletestring += " = " + datagrid.selectedItem.children()[x]; 
            	}else if(tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "DATE"){
            		deletestring += " = date'" + datagrid.selectedItem.children()[x] + "'"; 
            	}else {
            		deletestring += " = '" + datagrid.selectedItem.children()[x] + "'"; 
            	}
            	if (x + 1 < datagrid.selectedItem.children().length())
        			deletestring += " AND ";
            }
			
			var table:String = tablemetadata.getTable();
			var tableParts:Array = table.split(".");
			table = tableParts.join('"."');
			checksqlstring = "SELECT * FROM \"" + table + "\" WHERE " + deletestring;
			deletesql = "DELETE FROM \"" + table + "\" WHERE " + deletestring;
			
			DebugWindow.log("Delete String = " + deletesql);
			DebugWindow.log("Check String = " + checksqlstring);
            var delegate:GeneralDelegate = new GeneralDelegate(this, "sqlWebService");
            var args:Object = {connection: model.connectionVO.getConnectionString(),
                               testsql: checksqlstring,
                               sql: deletesql,
                               toomany: model.connectionVO.toomany
            };
            delegate.serviceDelegate("handleUpdate", args);
		}
		
		public function onResult(event:*=null):void
		{
			DebugWindow.log("DeleteRowCommand.as:onResult()");
			DebugWindow.log("DeleteRowCommand Data\n" + event.result.toString());
			var deleteresult:XML = new XML(event.result);
    		if(deleteresult.datamap == "Error"){
    			mx.controls.Alert.show(deleteresult.NewDataSet.Table.Error, "Delete Error");
    		} else{
                try {
                    model.query_results[VBox(model.main_tabnav.selectedChild).id].queryHistoryVO.writeHistory(deletesql, "");
                } catch(error:Error) {
                    model.query_results["qw-1"].queryHistoryVO.writeHistory(deletesql, "");
                }
    			tablewindow.refreshData();
        	}
		}
		
		public function onFault(event:*=null):void
		{
			DebugWindow.log("DeleteRowCommand.as:onFault()");
		}
		
	}
}
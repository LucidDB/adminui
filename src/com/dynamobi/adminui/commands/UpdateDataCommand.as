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
	import com.dynamobi.adminui.business.GeneralDelegate;
	import com.dynamobi.adminui.components.DebugWindow;
	import com.dynamobi.adminui.components.QueryWindow;
	import com.dynamobi.adminui.events.UpdateDataEvent;
	import com.dynamobi.adminui.model.ModelLocator;
	import com.dynamobi.adminui.view.OpenTableWindow;
	import com.dynamobi.adminui.vo.OpenTableData;
	
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.TextInput;
	import mx.events.DataGridEvent;

	public class UpdateDataCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		private var tablemetadata:OpenTableData;
		private var updatesql:String = "";
		private var datagrid:DataGrid;
		private var tablewindow:OpenTableWindow;
		private var itemevent:DataGridEvent;
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("UpdateDataCommand.as:execute()");
			tablemetadata = UpdateDataEvent(event).tablemetadata;
			datagrid = UpdateDataEvent(event).datagrid;
			tablewindow = UpdateDataEvent(event).tablewindow;
			itemevent = UpdateDataEvent(event).itemevent;
			var newdatafield:TextInput = TextInput(itemevent.currentTarget.itemEditorInstance);
			var table:String = tablemetadata.getTable();
			var tableParts:Array = table.split(".");
			table = tableParts.join('"."');
            updatesql = "UPDATE \"" + table + "\" SET \"" + itemevent.dataField + "\""; 
			if (newdatafield.text == "<NULL>")
				updatesql += " = NULL";
			else if(["MONEY", "SMALLMONEY", "INTEGER", "BOOLEAN", "DECIMAL", "REAL",
                    "FLOAT", "DOUBLE", "TINYINT",
                    "SMALLINT", "INT", "BIGINT"].indexOf(String(tablemetadata.getMetaData()[itemevent.dataField])) != -1)
				updatesql += " = " + newdatafield.text;
			else if(tablemetadata.getMetaData()[itemevent.dataField] == "DATE")
				updatesql += " = date'" + newdatafield.text + "'";
			else
				updatesql += " = '" + newdatafield.text + "'";
            updatesql += " WHERE ";
            DebugWindow.log("UpdateDataCommand.as:execute3()");
            var first_col:String = datagrid.columns[0].dataField;
            var whereclause:String = "LCS_RID(\"" + first_col + "\") = " +
                datagrid.selectedItem.children()[datagrid.selectedItem.children().length()-1];
			updatesql += whereclause;
			var checksql:String = "SELECT * FROM \"" + table + "\" WHERE " + whereclause;
			
			DebugWindow.log("Update String = " + updatesql);
			DebugWindow.log("Check String = " + checksql);
			
            var delegate:GeneralDelegate = new GeneralDelegate(this, "sqlWebService");
            var args:Object = {connection: model.connectionVO.getConnectionString(),
                testsql: checksql,
                sql: updatesql,
                toomany: model.connectionVO.toomany
            };
            delegate.serviceDelegate("handleUpdate", args);
		}
		
		public function onResult(event:*=null):void
		{
			DebugWindow.log("UpdateDataCommand.as:onResult()");
			DebugWindow.log("UpdateDataCommand Data\n" + event.result.toString());
			var updateresult:XML = new XML(event.result);
    		if(updateresult.datamap == "Error"){
    			mx.controls.Alert.show(updateresult.NewDataSet.Table.Error, "Update Error");
    			tablewindow.refreshData();
    		} else if(updateresult.recordcount == 0){
	        	mx.controls.Alert.show("Update Column Failed", "Update Error");
	        	tablewindow.refreshData();
	     	} else{
                try {
                    model.tabs[String(QueryWindow)][VBox(model.main_tabnav.selectedChild).id].result_info.queryHistoryVO.writeHistory(updatesql, "");
                } catch(error:Error) {
                    model.tabs[String(QueryWindow)][String(QueryWindow) + '-1'].result_info.queryHistoryVO.writeHistory(updatesql, "");
                }
        	}
		}
		
		public function onFault(event:*=null):void
		{
			DebugWindow.log("UpdateDataCommand.as:onResult()");
			DebugWindow.log("UpdateDataCommand Data\n" + event.result.toString());
		}
		
	}
}
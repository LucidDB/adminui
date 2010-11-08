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
package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.business.GeneralDelegate;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.components.QueryWindow;
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
		
		public function execute(event:CairngormEvent) : void {
			DebugWindow.log("DeleteRowCommand.as:execute()");
			tablemetadata = DeleteRowEvent(event).tablemetadata;
			datagrid = DeleteRowEvent(event).datagrid;
			tablewindow = DeleteRowEvent(event).tablewindow;
			
            var first_col:String = datagrid.columns[0].dataField;
            var deletestring:String = "LCS_RID(\"" + first_col + "\") = " +
                datagrid.selectedItem.children()[datagrid.selectedItem.children().length()-1];
			var table:String = tablemetadata.getTable();
			var tableParts:Array = table.split(".");
			table = tableParts.join('"."');
			var checksqlstring:String = "SELECT * FROM \"" + table + "\" WHERE " + deletestring;
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
                    model.tabs[String(QueryWindow)][VBox(model.main_tabnav.selectedChild).id].result_info.queryHistoryVO.writeHistory(deletesql, "");
                } catch(error:Error) {
                    model.tabs[String(QueryWindow)][String(QueryWindow) + '-1'].result_info.queryHistoryVO.writeHistory(deletesql, "");
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
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
	import com.dynamobi.adminui.events.InsertRowEvent;
	import com.dynamobi.adminui.model.ModelLocator;
	import com.dynamobi.adminui.view.InsertRowWindow;
	import com.dynamobi.adminui.vo.OpenTableData;
	
	import flash.events.Event;
	
	import mx.containers.VBox;
	import mx.controls.Alert;

	public class InsertRowCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		private var insertsql:String = "";
		private var tablemetadata:OpenTableData;
		private var formdata:Array;
		private var insertrowwindow:InsertRowWindow;
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("InsertRowCommand.as:execute()");
			tablemetadata = InsertRowEvent(event).tablemetadata;
			insertrowwindow = InsertRowEvent(event).insertrowwindow;
			formdata = insertrowwindow.getFormData();
			var tablexml:XML = tablemetadata.getTableXML();
			var table:String = tablemetadata.getTable();
			var tableParts:Array = table.split(".");
			table = tableParts.join('"."');
			insertsql = "INSERT INTO \"" + table + "\" (";
    		for (var x:int = 0; x < tablexml.NewDataSet.children().length(); x++){
    			if (formdata[x].text != "")
        			insertsql += "\"" + tablexml.NewDataSet.Table.COLUMN_NAME[x] + "\",";
    		}
    		insertsql = insertsql.substring(0, insertsql.length - 1);
    		insertsql += ") VALUES (";
    		for (x = 0; x < tablexml.NewDataSet.children().length(); x++){
    			if (formdata[x].text != ""){
    				if (["MONEY", "SMALLMONEY", "INTEGER", "BOOLEAN", "DECIMAL", "REAL",
                        "FLOAT", "DOUBLE", "TINYINT",
                        "SMALLINT", "INT", "BIGINT"].indexOf(String(tablexml.NewDataSet.Table.DATATYPE[x])) != -1){
    					insertsql += formdata[x].text + ", ";
    				} else if(tablexml.NewDataSet.Table.DATATYPE[x] == "DATE"){
    					insertsql += "date'" + formdata[x].text + "', ";
    				} else {
    					insertsql += "'" + formdata[x].text + "', ";
    				}
    			}
    		}
    		insertsql = insertsql.substring(0, insertsql.length - 2);
    		insertsql += ")";
			DebugWindow.log("Insert String = " + insertsql);
            var delegate:GeneralDelegate = new GeneralDelegate(this, "sqlWebService");
            var args:Object = {connection: model.connectionVO.getConnectionString(),
                sqlquerytype: "normal",
                sql: insertsql,
                toomany: model.connectionVO.toomany
            };
            delegate.serviceDelegate("execSQL", args);
		}
		
		public function onResult(event:*=null):void
		{
			DebugWindow.log("InsertRowCommand.as:onResult()");
			DebugWindow.log("InsertRowCommand Data\n" + event.result.toString());
			var insertresult:XML = new XML(event.result);
    		if(insertresult.datamap == "Error"){
    			mx.controls.Alert.show(insertresult.NewDataSet.Table.Error, "Insert Error");
    		} else{
                try {
                    model.tabs[String(QueryWindow)][VBox(model.main_tabnav.selectedChild).id].result_info.queryHistoryVO.writeHistory(insertsql, "");
                } catch(error:Error) {
                    model.tabs[String(QueryWindow)][String(QueryWindow) + '-1'].result_info.queryHistoryVO.writeHistory(insertsql, "");
                }
    			insertrowwindow.closeWin(new Event("CLOSED"));
    			insertrowwindow.getParentWindow().refreshData();
        	}
		}
		
		public function onFault(event:*=null):void
		{
		}
		
	}
}
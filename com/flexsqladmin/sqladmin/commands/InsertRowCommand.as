package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.business.GeneralDelegate;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.events.InsertRowEvent;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.view.InsertRowWindow;
	import com.flexsqladmin.sqladmin.vo.OpenTableData;
	
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
    				if (tablexml.NewDataSet.Table.DATATYPE[x] == "MONEY" || tablexml.NewDataSet.Table.DATATYPE[x] == "SMALLMONEY"){
    					insertsql += formdata[x].text + ", ";
    				} else if(tablexml.NewDataSet.Table.DATATYPE[x] == "INTEGER" || tablexml.NewDataSet.Table.DATATYPE[x] == "BOOLEAN"){
    					insertsql += formdata[x].text + ", ";
    				} else if(tablexml.NewDataSet.Table.DATATYPE[x] == "DATE"){
    					insertsql += "date'" + formdata[x].text + "', ";
    				}
    				
    				else {
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
                    model.query_results[VBox(model.main_tabnav.selectedChild).id].queryHistoryVO.writeHistory(insertsql, "");
                } catch(error:Error) {
                    model.query_results["qw-1"].queryHistoryVO.writeHistory(insertsql, "");
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
package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.business.GeneralDelegate;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.events.UpdateDataEvent;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.view.OpenTableWindow;
	import com.flexsqladmin.sqladmin.vo.OpenTableData;
	
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
			else if(tablemetadata.getMetaData()[itemevent.dataField] == "MONEY" || tablemetadata.getMetaData()[itemevent.dataField] == "SMALLMONEY")
				updatesql += " = " + newdatafield.text;
			else if(tablemetadata.getMetaData()[itemevent.dataField] == "BOOLEAN" || tablemetadata.getMetaData()[itemevent.dataField] == "INTEGER")
				updatesql += " = " + newdatafield.text;
			else if(tablemetadata.getMetaData()[itemevent.dataField] == "DATE")
				updatesql += " = date'" + newdatafield.text + "'";
			else
				updatesql += " = '" + newdatafield.text + "'";
            updatesql += " WHERE ";
            DebugWindow.log("UpdateDataCommand.as:execute3()");
            var whereclause:String = "";
			for(var x:int = 0; x < datagrid.columnCount ; x++){
				whereclause += "\"" + datagrid.columns[x].dataField + "\"";
				if (itemevent.currentTarget.editedItemRenderer.data[datagrid.columns[x].dataField] == "<NULL>"  || datagrid.columns[x].dataField.toString().toLowerCase() == 'null') {
					whereclause += " IS NULL";
				} else if(tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "MONEY" || tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "SMALLMONEY"){
					whereclause += " = " + itemevent.currentTarget.editedItemRenderer.data[datagrid.columns[x].dataField];
				} else if(tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "INTEGER" || tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "BOOLEAN"){
					whereclause += " = " + itemevent.currentTarget.editedItemRenderer.data[datagrid.columns[x].dataField];
				} else if(tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "DATE"){
					whereclause += " = date'" + itemevent.currentTarget.editedItemRenderer.data[datagrid.columns[x].dataField] + "'";
				} else {
					whereclause += " = '" + itemevent.currentTarget.editedItemRenderer.data[datagrid.columns[x].dataField] + "'"; 
				}
				if (x + 1 != datagrid.columnCount)
					whereclause += " AND ";
			}
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
                    model.query_results[VBox(model.main_tabnav.selectedChild).id].queryHistoryVO.writeHistory(updatesql, "");
                } catch(error:Error) {
                    model.query_results["qw-1"].queryHistoryVO.writeHistory(updatesql, "");
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
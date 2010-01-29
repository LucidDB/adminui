package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.business.Responder;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.vo.OpenTableData;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import com.flexsqladmin.sqladmin.view.OpenTableWindow;
	import mx.events.DataGridEvent;
	import com.flexsqladmin.sqladmin.events.UpdateDataEvent;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import mx.controls.TextInput;
	import com.flexsqladmin.sqladmin.business.handleUpdateDelegate;

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
            updatesql = "UPDATE [" + tablemetadata.getTable() + "] SET [" + itemevent.dataField + "]"; 
			if (newdatafield.text == "<NULL>")
				updatesql += " = NULL";
			else if(tablemetadata.getMetaData()[itemevent.dataField] == "money" || tablemetadata.getMetaData()[itemevent.dataField] == "smallmoney")
				updatesql += " = " + newdatafield.text;
			else
				updatesql += " = '" + newdatafield.text + "'";
            updatesql += " WHERE ";
            DebugWindow.log("UpdateDataCommand.as:execute3()");
            var whereclause:String = "";
			for(var x:int = 0; x < datagrid.columnCount ; x++){
				whereclause += "[" + datagrid.columns[x].dataField + "]";
				if (itemevent.currentTarget.editedItemRenderer.data[datagrid.columns[x].dataField] == "<NULL>"){
					whereclause += " IS NULL";
				} else if(tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "money" || tablemetadata.getMetaData()[datagrid.columns[x].dataField] == "smallmoney"){
					whereclause += " = " + itemevent.currentTarget.editedItemRenderer.data[datagrid.columns[x].dataField];
				} else {
					whereclause += " = '" + itemevent.currentTarget.editedItemRenderer.data[datagrid.columns[x].dataField] + "'"; 
				}
				if (x + 1 != datagrid.columnCount)
					whereclause += " AND ";
			}
			updatesql += whereclause;
			var checksql:String = "SELECT * FROM [" + tablemetadata.getTable() + "] WHERE " + whereclause;
			
			DebugWindow.log("Update String = " + updatesql);
			DebugWindow.log("Check String = " + checksql);
			
			var delegate:handleUpdateDelegate = new handleUpdateDelegate(this);
			delegate.handleUpdate(updatesql, checksql, model.connectionVO);
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
    			model.queryHistoryVO.writeHistory(updatesql, "");
        	}
		}
		
		public function onFault(event:*=null):void
		{
			DebugWindow.log("UpdateDataCommand.as:onResult()");
			DebugWindow.log("UpdateDataCommand Data\n" + event.result.toString());
		}
		
	}
}
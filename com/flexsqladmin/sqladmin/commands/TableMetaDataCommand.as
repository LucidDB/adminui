package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.business.Responder;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.events.TableMetaDataEvent;
	import com.flexsqladmin.sqladmin.business.execSQLDelegate;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.vo.OpenTableData;

	public class TableMetaDataCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		private var tablemetadata:OpenTableData;
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("TableMetaDataCommand.as:execute()");
			tablemetadata = TableMetaDataEvent(event).tablemetadata;
			var delegate:execSQLDelegate = new execSQLDelegate(this);
			delegate.execSQL("SELECT column_name, data_type, is_nullable, ISNULL(character_maximum_length, '') AS character_maximum_length FROM information_schema.columns WHERE table_name = '" + tablemetadata.getTable() + "'", "meta", model.connectionVO);
		}
		
		public function onResult(event:*=null):void
		{
			DebugWindow.log("TableMetaDataCommand.as:onResult()");
			DebugWindow.log("TableMetaDataCommand Data\n" + event.result.toString());
			var mdarray:Array = new Array();
			var metadata:XML = new XML(event.result);
			for (var x:int = 0; x < metadata.NewDataSet.children().length(); x++){
				mdarray[metadata.NewDataSet.Table.column_name[x]] = metadata.NewDataSet.Table.data_type[x];
    		}
    		tablemetadata.setMetaData(mdarray);
    		tablemetadata.setTableXML(metadata);
    		//DebugWindow.log("Array - " + mdarray.length.toString());
    		//DebugWindow.log("Length - " + metadata.NewDataSet.children().length().toString());
		}
		
		public function onFault(event:*=null):void
		{
			DebugWindow.log("OpenTableCommand.as:onFault()");
		}
		
	}
}
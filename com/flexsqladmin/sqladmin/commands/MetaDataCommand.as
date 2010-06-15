package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.events.MetaDataEvent
	import com.flexsqladmin.sqladmin.business.getDBMetaDataDelegate;
	import com.flexsqladmin.sqladmin.vo.ConnectionVO;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.events.MetaDataEvent;
	
	public class MetaDataCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("MetaDataCommand:execute()");
			var delegate:getDBMetaDataDelegate = new getDBMetaDataDelegate(this);
			var metaevent:MetaDataEvent = MetaDataEvent(event);
			var catalog:String = metaevent.catalog_name;
			model.currentcatalogname = catalog;
			delegate.getDBMetaData(catalog,model.connectionVO);

		}

		public function onResult(event:*=null):void
		{
			DebugWindow.log("MetaDataCommand:onResult()");
			//DebugWindow.log("Web Service Result\n" + event.result.toString());
			model.metadata = new XML(event.result);
		}
		
		public function onFault(event:*=null):void
		{
			DebugWindow.log("MetaDataCommand:onFault()");
		}
	}
}
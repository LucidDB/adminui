package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.business.GeneralDelegate;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.events.MetaDataEvent;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.vo.ConnectionVO;
	
	import mx.core.Application;
	
	public class MetaDataCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("MetaDataCommand:execute()");
			var metaevent:MetaDataEvent = MetaDataEvent(event);
			var catalog:String = metaevent.catalog_name;
			model.currentcatalogname = catalog;
            
            var delegate:GeneralDelegate = new GeneralDelegate(this, "sqlWebService");
            var args:Object = {connection: "",
                catalog: catalog
            };
            delegate.serviceDelegate("getDBMetaData", args);
		}

		public function onResult(event:*=null):void
		{
			DebugWindow.log("MetaDataCommand:onResult()");
            model.metadata = new XML(event.result);
            //trace(model.metadata.toXMLString());
        }
		
		public function onFault(event:*=null):void
		{
			DebugWindow.log("MetaDataCommand:onFault()");
		}
	}
}
package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.business.execSQLDelegate;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	
	import mx.collections.XMLListCollection;
	
	public class ListCatalogsCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("ListCatalogsCommand:execute()");
			var delegate:execSQLDelegate = new execSQLDelegate(this);
			var sql:String = "SELECT distinct CATALOG_NAME  FROM SYS_ROOT.DBA_SCHEMAS order by CATALOG_NAME";
			var querytype:String = "normal";
			delegate.execSQL(sql,querytype,model.connectionVO)
		}

		public function onResult(event:*=null):void
		{
			DebugWindow.log("ListCatalogsCommand:onResult()");
			//DebugWindow.log("Web Service Result\n" + event.result.toString());
			var queryxml:XML = new XML(event.result);
			model.catalogdata = new XMLListCollection(queryxml.NewDataSet.Table);
            model.currentcatalogname = model.catalogdata.child(0)[0].toString();			
		}
		
		public function onFault(event:*=null):void
		{
			DebugWindow.log("ListCatalogsCommand:onFault()");
		}
	}
}
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
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	
	import mx.collections.XMLListCollection;
	
	public class ListCatalogsCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("ListCatalogsCommand:execute()");
			var sql:String = "SELECT distinct CATALOG_NAME  FROM SYS_ROOT.DBA_SCHEMAS order by CATALOG_NAME";
			var querytype:String = "normal";

            var delegate:GeneralDelegate = new GeneralDelegate(this, "sqlWebService");
            var args:Object = {connection: model.connectionVO.getConnectionString(),
                sqlquerytype: querytype,
                sql: sql,
                toomany: model.connectionVO.toomany
            };
            delegate.serviceDelegate("execSQL", args);
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
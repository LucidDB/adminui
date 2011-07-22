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
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.dynamobi.adminui.business.GeneralDelegate;
	import com.dynamobi.adminui.components.DebugWindow;
	import com.dynamobi.adminui.events.GeneralServiceEvent;
	import com.dynamobi.adminui.model.ModelLocator;
	
	import mx.collections.XMLListCollection;
	import mx.core.FlexGlobals;
	
	public class ListCatalogsCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("ListCatalogsCommand:execute()");
			var sql:String = "SELECT distinct CATALOG_NAME  FROM localdb.SYS_ROOT.DBA_SCHEMAS order by CATALOG_NAME";
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
            // What idiot programmed this? Oh, me. -ks (replacement isn't much better but does what we want)
            //model.currentcatalogname = model.catalogdata.child(0)[0].toString();
            var cat_event:GeneralServiceEvent = new GeneralServiceEvent(GeneralCommand, 'getCurrentCatalog',
                null, {'callback': function(r:*) : void {
                        model.currentcatalogname = XML(r)['return'].@name.toString();
                        for (var i:Number = 0;
                            i < FlexGlobals.topLevelApplication.mycatalog.dataProvider.length; i++) {
                            if (FlexGlobals.topLevelApplication.mycatalog.dataProvider[i].CATALOG_NAME
                                == model.currentcatalogname) {
                                FlexGlobals.topLevelApplication.mycatalog.selectedIndex = i;
                                break;
                            }
                        }
                    }}, 'sqlWebService');
            CairngormEventDispatcher.getInstance().dispatchEvent(cat_event);
		}
		
		public function onFault(event:*=null):void
		{
			DebugWindow.log("ListCatalogsCommand:onFault()");
		}
	}
}
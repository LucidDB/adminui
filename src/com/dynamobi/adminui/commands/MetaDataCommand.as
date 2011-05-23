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
	import com.flexsqladmin.sqladmin.events.MetaDataEvent;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.vo.ConnectionVO;
	
	import mx.core.FlexGlobals;
	
	public class MetaDataCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
            /* This class used to get new data when a catalog changes or on refresh...*/
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
            //trace(String(event.result));
            XML(model.object_tree.tree_data.schemas).setChildren(new XML(event.result).children());
            model.object_tree.addSchemaElementLoaders();
            //model.metadata = new XML(event.result);
        }
		
		public function onFault(event:*=null):void
		{
			DebugWindow.log("MetaDataCommand:onFault()");
		}
	}
}
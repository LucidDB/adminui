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
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.business.Responder;
	import com.dynamobi.adminui.components.DebugWindow;
	import com.dynamobi.adminui.events.TableMetaDataEvent;
	import com.dynamobi.adminui.business.GeneralDelegate;
	import com.dynamobi.adminui.model.ModelLocator;
	import com.dynamobi.adminui.vo.OpenTableData;

	public class TableMetaDataCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		private var tablemetadata:OpenTableData;
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("TableMetaDataCommand.as:execute()");
			tablemetadata = TableMetaDataEvent(event).tablemetadata;
            
            var delegate:GeneralDelegate = new GeneralDelegate(this, "sqlWebService");
            var args:Object = {connection: model.connectionVO.getConnectionString(),
                sqlquerytype: "meta",
                sql: "SELECT column_name, datatype, is_nullable AS IS_NULLABLE, " +
                    "\"PRECISION\" AS character_maximum_length " +
                    "FROM SYS_ROOT.DBA_COLUMNS " +
                    "WHERE table_name = '" + tablemetadata.getTable().split(".")[1] + "'",
                toomany: model.connectionVO.toomany
            };
            delegate.serviceDelegate("execSQL", args);
		}
		
		public function onResult(event:*=null):void
		{
			DebugWindow.log("TableMetaDataCommand.as:onResult()");
			DebugWindow.log("TableMetaDataCommand Data\n" + event.result.toString());
			var mdarray:Array = new Array();
			var metadata:XML = new XML(event.result);
			for (var x:int = 0; x < metadata.NewDataSet.children().length(); x++){
				mdarray[metadata.NewDataSet.Table.COLUMN_NAME[x]] = metadata.NewDataSet.Table.DATATYPE[x];
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
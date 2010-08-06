/*
Copyright 2006-2010 Kevin Kazmierczak. All rights reserved.
Copyright 2010 Dynamo Business Intelligence Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY Dynamo Business Intelligence Corporation ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Dynamo Business Intelligence Corporation OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.business.GeneralDelegate;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.events.OpenTableEvent;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	
	import mx.collections.XMLListCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;

	public class OpenTableCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		private var tabledatagrid:DataGrid;
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("OpenTableCommand.as:execute()");
			var table:String = OpenTableEvent(event).table;
			var tableParts:Array = table.split(".");
			table = tableParts.join('"."');
			tabledatagrid = OpenTableEvent(event).tabledatagrid;
            
            var delegate:GeneralDelegate = new GeneralDelegate(this, "sqlWebService");
            var args:Object = {connection: model.connectionVO.getConnectionString(),
                sqlquerytype: "normal",
                sql: "SELECT * FROM \"" + table + "\"",
                toomany: model.connectionVO.toomany
            };
            delegate.serviceDelegate("execSQL", args);
		}
		
		public function onResult(event:*=null):void
		{
			DebugWindow.log("OpenTableCommand.as:onResult()");
			DebugWindow.log("OpenTable Data\n" + event.result.toString());
			var cols:Array = new Array();
            var dgcols:Array = new Array();

			//getTableMetaData();
            var tablexml:XML = new XML(event.result);
            var tabledata:XMLListCollection = new XMLListCollection(tablexml.NewDataSet.Table);
            cols = tablexml.datamap.split(",");
            for(var k:int;k < cols.length;k++){
                var dgcolumn:DataGridColumn = new DataGridColumn(cols[k]);
                dgcolumn.dataTipField = cols[k];
                dgcolumn.dataField = cols[k];
                if(tablexml.edittable == "false")
                	dgcolumn.editable = false;
                dgcols.push(dgcolumn);
            }
            tabledatagrid.dataProvider = tabledata
            tabledatagrid.columns = dgcols;
		}
		
		public function onFault(event:*=null):void
		{
			DebugWindow.log("OpenTableCommand.as:onFault()");
		}
		
	}
}
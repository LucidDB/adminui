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
            var col_list:String = OpenTableEvent(event).col_list.replace(new RegExp('&quot;', 'g'), '"');
            var first_col:String = col_list.split(',')[0];
            
            var delegate:GeneralDelegate = new GeneralDelegate(this, "sqlWebService");
            var args:Object = {connection: model.connectionVO.getConnectionString(),
                sqlquerytype: "normal",
                sql: "SELECT " + col_list + ", LCS_RID(" + first_col + ") as UNIQUE_LCS_RID" +
                    " FROM \"" + table + "\"",
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
            // Set the LCS_RID to invisible
            DataGridColumn(dgcols[dgcols.length-1]).visible = false;
            tabledatagrid.dataProvider = tabledata
            tabledatagrid.columns = dgcols;
		}
		
		public function onFault(event:*=null):void
		{
			DebugWindow.log("OpenTableCommand.as:onFault()");
		}
		
	}
}
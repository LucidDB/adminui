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
package com.dynamobi.adminui.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.dynamobi.adminui.components.DebugWindow;
	
	import mx.controls.DataGrid;
	
	public class ExecuteSQLEvent extends CairngormEvent
	{
		public var sql:String = "";
		public var sqlquerytype:String = "";
		public var querydatagrid:DataGrid;
        public var func:Function;
		
		public static var EXECUTESQL:String = "executeSQL";
		
		public function ExecuteSQLEvent(s:String, sqt:String, func:Function=null)
		{
			DebugWindow.log("ExecuteSQLEvent.as:ExecuteSQLEvent('" + s + "', '" + sqt + "')");
			super(EXECUTESQL);
			sql = s; 
			sqlquerytype = sqt;
            this.func = func;
		}
	}
}
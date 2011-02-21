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
package com.flexsqladmin.sqladmin.events
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.utils.ActionEnum;
    import com.flexsqladmin.sqladmin.view.NewSchemaWindow;
    
    public class TableDetailsEvent extends CairngormEvent {
        public static var TABLEDETAILS:String = "tabledetails";
        
        public var catalog:String;
        public var schema:String;
        public var table:String;
        public var action:ActionEnum;
        public var details:XML;
        public var win_hack:NewSchemaWindow;

        public function TableDetailsEvent(cat:String, sch:String, tab:String, act:ActionEnum, det:XML=null, win_hack:NewSchemaWindow=null) {
            DebugWindow.log("TableDetailsEvent.as");
            super(TABLEDETAILS);
            
            catalog = cat;
            schema = sch;
            table = tab;
            action = act;
            details = det;
            this.win_hack = win_hack;
        }
    }
}
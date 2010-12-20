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
    import com.adobe.cairngorm.control.CairngormEventDispatcher;
    import com.flexsqladmin.sqladmin.business.tableDetailsDelegate;
    import com.flexsqladmin.sqladmin.components.CreateEditTableWindow;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.events.TableDetailsEvent;
    import com.flexsqladmin.sqladmin.model.ModelLocator;
    import com.flexsqladmin.sqladmin.utils.ActionEnum;
    
    import flash.events.Event;
    
    import mx.containers.VBox;
    import mx.controls.Alert;
    import mx.core.FlexGlobals;

    public class TableDetailsCommand implements Command, Responder {

        private var model:ModelLocator = ModelLocator.getInstance();
        private var request_type:ActionEnum;
        
        private var schema:String;
        private var table:String;
        private var details:XML;
        
        public function execute(event:CairngormEvent) : void {
            DebugWindow.log("TableDetails:execute()");
            var cat:String = TableDetailsEvent(event).catalog;
            schema = TableDetailsEvent(event).schema;
            table = TableDetailsEvent(event).table;
            var action:ActionEnum = TableDetailsEvent(event).action;
            details = TableDetailsEvent(event).details;
            request_type = action;
            
            var delegate:tableDetailsDelegate = new tableDetailsDelegate(this);
            if (action == ActionEnum.GET)
                delegate.getTableDetails(cat, schema, table);
            else if (action == ActionEnum.POST)
                delegate.postTableDetails(cat, schema, table, details);
            else if (action == ActionEnum.PUT)
                delegate.createSchema(cat, schema);
        }
        
        public function onResult(event:*=null) : void {
            if (request_type == ActionEnum.GET)
                onGetResult(event);
            else if (request_type == ActionEnum.POST)
                onPostResult(event);
            else if (request_type == ActionEnum.PUT)
                onPutResult(event);
        }
        
        // for gets:
        public function onGetResult(event:*=null) : void {
            DebugWindow.log("TableDetailsCommand:onGetResult()");
            var r:XML = new XML(event.result);
            if(r.datamap == "Error"){
                var errormsg:String = r.NewDataSet.Table.Error;
                DebugWindow.log("Error - " + errormsg);
            } else {
                model.tabs[String(CreateEditTableWindow)][VBox(model.main_tabnav.selectedChild).id].TD.details = new XML(XML(event.result['return']));
                CreateEditTableWindow(VBox(model.main_tabnav.selectedChild).getChildAt(0)).addColumnsFromDetails();
            }            
        }
        
        // for posts:
        public function onPostResult(event:*=null) : void {
            DebugWindow.log("TableDetailsCommand:onPostResult()");
            var r:XML = new XML(event.result);
            if (r.datamap == "Error") {
                var errormsg:String = r.NewDataSet.Table.Error;
                DebugWindow.log("Error - " + errormsg);
            } else {
                var response:String = event.result['return'];
                if (response == "true") {
                    Alert.show("Execution Succeeded", "Success");
                    model.object_tree.addTable(schema, table, details);
                } else {
                    Alert.show("Execution Failed", "Error");
                }
            }
        }
        
        public function onPutResult(event:*=null) : void {
            DebugWindow.log("TableDetailsCommand:onPutResult()");
            var r:XML = new XML(event.result);
            if (r.datamap == "Error") {
                var errormsg:String = r.NewDataSet.Table.Error;
                DebugWindow.log("Error - " + errormsg);                
            } else {
                var response:String = event.result;
                if (response.length == 0) {
                    Alert.show("Schema created.", "Success");
                    model.object_tree.addSchema(schema);
                } else {
                    Alert.show("Schema could not be created.", "Error");
                }
            }
        }
        
        public function onFault(event:*=null) : void {
            DebugWindow.log("TableDetailsCommand:onFault()");
        }
    }
}
/*
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
    import mx.core.Application;

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
                model.tabs[String(CreateEditTableWindow)][VBox(model.main_tabnav.selectedChild).id].details = new XML(XML(event.result['return']));
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
                    model.object_tree.addSchema(schema.toUpperCase());
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
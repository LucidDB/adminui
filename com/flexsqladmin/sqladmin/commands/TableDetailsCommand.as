package com.flexsqladmin.sqladmin.commands
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.commands.Command;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.adobe.cairngorm.control.CairngormEventDispatcher;
    import com.flexsqladmin.sqladmin.business.execSQLDelegate;
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
        
        public function execute(event:CairngormEvent) : void {
            DebugWindow.log("TableDetails:execute()");
            var cat:String = TableDetailsEvent(event).catalog;
            var schema:String = TableDetailsEvent(event).schema;
            var table:String = TableDetailsEvent(event).table;
            var action:ActionEnum = TableDetailsEvent(event).action;
            var details:XML = TableDetailsEvent(event).details;
            var delegate:tableDetailsDelegate = new tableDetailsDelegate(this);
            request_type = action;
            if (action == ActionEnum.GET)
                delegate.getTableDetails(cat, schema, table);
            else if (action == ActionEnum.POST)
                delegate.postTableDetails(cat, schema, table, details);
        }
        
        public function onResult(event:*=null) : void {
            if (request_type == ActionEnum.GET)
                onGetResult(event);
            else if (request_type == ActionEnum.POST)
                onPostResult(event);
        }
        
        // for gets:
        public function onGetResult(event:*=null) : void {
            DebugWindow.log("TableDetailsCommand:onGetResult()");
            var r:XML = new XML(event.result);
            if(r.datamap == "Error"){
                var errormsg:String = r.NewDataSet.Table.Error;
                DebugWindow.log("Error - " + errormsg);
            } else {
                model.table_details[VBox(model.main_tabnav.selectedChild).id].details = new XML(XML(event.result['return']));
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
                    Alert.show("Execution Succeeded");
                } else {
                    Alert.show("Execution Failed");
                }
                /*var response:XML = new XML(XML(event.result['return']));
                trace(response);*/
            }
        }
        
        public function onFault(event:*=null) : void {
            DebugWindow.log("TableDetailsCommand:onFault()");
        }
    }
}
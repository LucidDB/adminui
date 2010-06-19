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
    
    import mx.controls.Alert;
    import mx.core.Application;

    public class TableDetailsCommand implements Command, Responder {

        private var model:ModelLocator = ModelLocator.getInstance();
        
        public function execute(event:CairngormEvent) : void {
            DebugWindow.log("TableDetails:execute()");
            var cat:String = TableDetailsEvent(event).catalog;
            var schema:String = TableDetailsEvent(event).schema;
            var table:String = TableDetailsEvent(event).table;
            var action:ActionEnum = TableDetailsEvent(event).action;
            var delegate:tableDetailsDelegate = new tableDetailsDelegate(this);
            if (action == ActionEnum.GET)
                delegate.getTableDetails(cat, schema, table);
            //var delegate:execSQLDelegate = new execSQLDelegate(this);
            //delegate.execSQL(sql, sqlquerytype, model.tempConnectionVO);
        }
        
        // for gets:
        public function onResult(event:*=null) : void {
            DebugWindow.log("TableDetailsCommand:onResult()");
            var r:XML = new XML(event.result);
            if(r.datamap == "Error"){
                var errormsg:String = r.NewDataSet.Table.Error;
                DebugWindow.log("Error - " + errormsg);
            } else {
                model.table_details[model.main_tabnav.selectedChild.id].details = new XML(XML(event.result['return']));
                CreateEditTableWindow(model.main_tabnav.selectedChild.getChildAt(0)).addColumnsFromDetails();
            }

        }
        
        // for posts:
        
        public function onFault(event:*=null) : void {
            DebugWindow.log("TableDetailsCommand:onFault()");
        }
    }
}
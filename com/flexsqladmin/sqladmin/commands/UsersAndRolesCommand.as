package com.flexsqladmin.sqladmin.commands
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.commands.Command;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.adobe.cairngorm.control.CairngormEventDispatcher;
    import com.flexsqladmin.sqladmin.business.UsersAndRolesDelegate;
    import com.flexsqladmin.sqladmin.business.execSQLDelegate;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.events.UsersAndRolesEvent;
    import com.flexsqladmin.sqladmin.model.ModelLocator;
    import com.flexsqladmin.sqladmin.utils.ActionEnum;
    
    import flash.events.Event;
    
    import mx.containers.VBox;
    import mx.controls.Alert;
    import mx.core.Application;

    public class UsersAndRolesCommand implements Command, Responder {
        private var model:ModelLocator = ModelLocator.getInstance();
        private var request_type:ActionEnum;
        
        private var call:String;
        
        public function execute(event:CairngormEvent) : void {
            DebugWindow.log("UsersAndRolesCommand:execute()");
            call = UsersAndRolesEvent(event).call;
            var delegate:UsersAndRolesDelegate = new UsersAndRolesDelegate(this);
            if (call == 'getCurrentSessions')
                delegate.getCurrentSessions();
            else if (call == 'getUsersDetails')
                delegate.getUsersDetails();
        }
        
        public function onResult(event:*=null) : void {
            var r:XML = new XML(event.result);
            if(r.datamap == "Error"){
                var errormsg:String = r.NewDataSet.Table.Error;
                DebugWindow.log("Error - " + errormsg);
            } else {
                if (call == 'getCurrentSessions') {
                    DebugWindow.log("UsersAndRolesCommand.as:onResult()-getCurrentSessions");
                    model.session_info = new XMLList(XML(event.result).children());
                } else if (call == 'getUsersDetails') {
                    DebugWindow.log("UsersAndRolesCommand.as:onResult()-getUsersDetails");
                    model.users_details = new XMLList(XML(event.result).children());
                    model.users_list = new Array();
                    for each (var el:XML in model.users_details) {
                        model.users_list.push(el.@name);
                    }
                }
            }
        }
                
       public function onFault(event:*=null) : void {
            DebugWindow.log("UsersAndRolesCommand:onFault()");
        }
   }
}
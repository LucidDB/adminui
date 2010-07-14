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
    import mx.managers.CursorManager;

    public class UsersAndRolesCommand implements Command, Responder {
        private var model:ModelLocator = ModelLocator.getInstance();
        private var request_type:ActionEnum;
        
        private var call:String;
        private var user:String;
        private var pass:String;
        private var role_name:String;
        private var added:String;
        private var with_grant:String;
        private var perms_list:Array;
        
        public function execute(event:CairngormEvent) : void {
            DebugWindow.log("UsersAndRolesCommand:execute()");
            call = UsersAndRolesEvent(event).call;
            user = UsersAndRolesEvent(event).user;
            pass = UsersAndRolesEvent(event).pass;
            role_name = UsersAndRolesEvent(event).role_name;
            added = UsersAndRolesEvent(event).added;
            with_grant = UsersAndRolesEvent(event).with_grant;
            perms_list = UsersAndRolesEvent(event).perms_list;
            
            CursorManager.setBusyCursor();
            var delegate:UsersAndRolesDelegate = new UsersAndRolesDelegate(this);
            
            if (call == 'getCurrentSessions')
                CursorManager.removeBusyCursor();
            
            var args:Object;
            if (role_name == '') {
                args = {user: user, password: pass};
            } else if (added != '') {
                args = {user: user, role: role_name, added: added, with_grant: with_grant};
            } else if (perms_list != null) {
                args = {elements: perms_list};
            } else {
                args = {role: role_name};
            }
            delegate.serviceDelegate(call, args);

        }
        
        public function onResult(event:*=null) : void {
            CursorManager.removeBusyCursor();
            var r:XML = new XML(event.result);
            if(r.datamap == "Error"){
                var errormsg:String = r.NewDataSet.Table.Error;
                DebugWindow.log("Error - " + errormsg);
            } else {
                var response:String;
                if (call == 'getCurrentSessions') {
                    DebugWindow.log("UsersAndRolesCommand.as:onResult()-getCurrentSessions");
                    /*if (model.session_info)
                        model.session_info += new XMLList(XML(event.result).children());
                    else*/
                    model.session_info = new XMLList(XML(event.result).children());
                } else if (call == 'getUsersDetails') {
                    DebugWindow.log("UsersAndRolesCommand.as:onResult()-getUsersDetails");
                    model.users_details = new XMLList(XML(event.result).children());
                    model.users_list = new Array();
                    for each (var el:XML in model.users_details) {
                        model.users_list.push(el.@name);
                    }
                } else if (call == 'getRolesDetails') {
                    DebugWindow.log("UsersAndRolesCommand.as:onResult()-getRolesDetails");
                    model.roles_info = new XML(XML(event.result).children());
                    model.roles_list = new Array();
                    for each (el in model.roles_info.children()) {
                        model.roles_list.push(el.@name);
                    }
                } else if (call == 'addNewUser') {
                    DebugWindow.log("UsersAndRolesCommand.as:onResult()-addNewUser");
                    response = event.result;
                    if (response == "") {
                        Alert.show("New User Created", "Success", 4, null, function():void {
                            var usersEvent:UsersAndRolesEvent = new UsersAndRolesEvent('getUsersDetails');
                            CairngormEventDispatcher.getInstance().dispatchEvent(usersEvent);
                        });
                    } else {
                        Alert.show("Could not create user: " + response, "Error");
                    }
                } else if (call == 'addNewRole') {
                    DebugWindow.log("UsersAndRolesCommand.as:onResult()-addNewRole");
                    response = event.result;
                    if (response == "") {
                        Alert.show("New Role Created", "Success", 4, null, function():void {
                            var rolesEvent:UsersAndRolesEvent = new UsersAndRolesEvent('getRolesDetails');
                            CairngormEventDispatcher.getInstance().dispatchEvent(rolesEvent);
                        });
                    } else {
                        Alert.show("Could not create role: " + response, "Error");
                    }
                } else if (call == 'deleteUser') {
                    DebugWindow.log("UsersAndRolesCommand.as:onResult()-deleteUser");
                    response = event.result;
                    if (response == "") {
                        var usersEvent:UsersAndRolesEvent = new UsersAndRolesEvent('getUsersDetails');
                        CairngormEventDispatcher.getInstance().dispatchEvent(usersEvent);
                        Alert.show("User Deleted", "Success");
                    } else {
                        Alert.show("Could not delete user: " + response, "Error");
                    }
                } else if (call == 'deleteRole') {
                    DebugWindow.log("UsersAndRolesCommand.as:onResult()-deleteRole");
                    response = event.result;
                    if (response == "") {
                        usersEvent = new UsersAndRolesEvent('getRolesDetails');
                        CairngormEventDispatcher.getInstance().dispatchEvent(usersEvent);
                        Alert.show("Role Deleted", "Success");
                    } else {
                        Alert.show("Could not delete role: " + response, "Error");
                    }
                } else if (call == 'modifyUser') {
                    DebugWindow.log("UsersAndRolesCommand.as:onResult()-modifyUser");
                    response = event.result;
                    if (response == "") {
                        usersEvent = new UsersAndRolesEvent('getUsersDetails');
                        CairngormEventDispatcher.getInstance().dispatchEvent(usersEvent);
                        Alert.show("User Changed", "Success");
                    } else {
                        Alert.show("Could not change user: " + response, "Error");
                    }
                }
            }
        }
                
       public function onFault(event:*=null) : void {
            DebugWindow.log("UsersAndRolesCommand:onFault()");
        }
   }
}
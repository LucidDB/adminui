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
    import com.flexsqladmin.sqladmin.business.GeneralDelegate;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.components.UsersAndRolesWindow;
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
        
        private var total_calls:Number;
        private var call_successes:Array;
        private var call_fails:Array;
        
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
            var delegate:GeneralDelegate = new GeneralDelegate(this, "UsersAndRolesService");
            
            if (call == 'getCurrentSessions')
                CursorManager.removeBusyCursor();
            
            total_calls = 0;
            call_successes = [];
            call_fails = [];
            
            var args:Object;
            if (perms_list != null) {
                //call = call.slice(0, -1);
                var grantee:String = (role_name == '') ? user : role_name;
                for each (var perm:XML in perms_list) {
                    var real_call:String = call;
                    var perms:String = String(perm.@perms).replace(' ', ',').replace('ALL', 'ALL PRIVILEGES');
                    if (perm.@level == 'schema') {
                        real_call += 'OnSchema';
                        args = {catalog: model.currentcatalogname, schema: perm.@name,
                            permissions: perms, grantee: grantee};
                    } else if (perm.@level == 'item') {
                        args = {catalog: model.currentcatalogname, schema: perm.@schemaName,
                            type: perm.@type, element: perm.@name, permissions: perms,
                            grantee: grantee};
                    }
                    total_calls += 1;
                    delegate.serviceDelegate(real_call, args);
                }
                return;
            } else if (role_name == '') {
                args = {user: user, password: pass};
            } else if (added != '') {
                args = {user: user, role: role_name, added: added, with_grant: with_grant};
            } else {
                args = {role: role_name};
            }
            total_calls += 1;
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
                    CursorManager.removeBusyCursor();
                    DebugWindow.log("UsersAndRolesCommand.as:onResult()-getRolesDetails");
                    model.roles_info = new XML(XML(event.result).children());
                    model.roles_list = new Array();
                    for each (el in model.roles_info.children()) {
                        model.roles_list.push(el.@name);
                    }
                    try {
                        model.tabs[String(UsersAndRolesWindow)][VBox(model.main_tabnav.selectedChild).id].rw.select_role();
                    } catch (e:Error) {
                        //pass
                    }
                } else if (call == 'addNewUser') {
                    DebugWindow.log("UsersAndRolesCommand.as:onResult()-addNewUser");
                    response = event.result;
                    if (response == "") {
                        model.tabs[String(UsersAndRolesWindow)][VBox(model.main_tabnav.selectedChild).id].set_user_mode('edit', user.toUpperCase());
                        model.object_tree.addItem('user', user.toUpperCase(), 'security', 'users');
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
                        model.tabs[String(UsersAndRolesWindow)][VBox(model.main_tabnav.selectedChild).id].set_role_mode('edit', role_name.toUpperCase());
                        model.object_tree.addItem('role', role_name.toUpperCase(), 'security', 'roles');
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
                } else if (call == 'grantPermissions' || call == 'revokePermissions') {
                    DebugWindow.log("UsersAndRolesCommand.as:onResult()-grant or revoke");
                    response = event.result;
                    if (response == "") {
                        call_successes.push('');
                    } else {
                        call_fails.push(response);
                    }
                    if (call_successes.length + call_fails.length == total_calls) {
                        usersEvent = new UsersAndRolesEvent('getRolesDetails');
                        CairngormEventDispatcher.getInstance().dispatchEvent(usersEvent);
                        if (call_fails.length == 0) {
                            Alert.show("All permission changes successful", "Success");
                        } else {
                            var responses:String = call_fails.join("\n");
                            Alert.show("Some permission changes failed, here are the details:\n" + responses, "Warning");
                        }
                    }
                }
            }
        }
                
       public function onFault(event:*=null) : void {
           CursorManager.removeBusyCursor();
            DebugWindow.log("UsersAndRolesCommand:onFault()");
        }
   }
}
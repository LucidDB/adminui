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
    import com.flexsqladmin.sqladmin.business.GeneralDelegate;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.components.UsersAndRolesWindow;
    import com.flexsqladmin.sqladmin.events.UsersAndRolesEvent;
    import com.flexsqladmin.sqladmin.model.ModelLocator;
    import com.flexsqladmin.sqladmin.utils.ActionEnum;
    
    import flash.events.Event;
    
    import mx.containers.VBox;
    import mx.controls.Alert;
    import mx.core.FlexGlobals;
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
            
            CursorManager.setBusyCursor();
            var delegate:GeneralDelegate = new GeneralDelegate(this, "UsersAndRolesService");
            
            if (call == 'getCurrentSessions')
                CursorManager.removeBusyCursor();
            
            total_calls = 0;
            call_successes = [];
            call_fails = [];
            
            var args:Object;
            if (role_name == '') {
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
                    var scroll:Number = model.session_tab.session_info.verticalScrollPosition;
                    model.session_tab.session_info_data = new XMLList(XML(event.result).children());
                    model.session_tab.session_info.invalidateDisplayList();
                    model.session_tab.session_info.validateNow();
                    model.session_tab.session_info.verticalScrollPosition = scroll;
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
                        if (XML(el).localName() == 'role')
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
                        model.tabs[String(UsersAndRolesWindow)][VBox(model.main_tabnav.selectedChild).id].set_user_mode('edit', user, true);
                        model.object_tree.addItem('user', user, 'security', 'users');
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
                }
            }
        }
                
       public function onFault(event:*=null) : void {
           CursorManager.removeBusyCursor();
            DebugWindow.log("UsersAndRolesCommand:onFault()");
        }
   }
}
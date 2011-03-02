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
    
    public class UsersAndRolesEvent extends CairngormEvent {
        public static var USERSANDROLES:String = "usersandroles";
        
        public var call:String;
        public var user:String;
        public var pass:String;
        public var role_name:String;
        public var added:String;
        public var with_grant:String;

        public function UsersAndRolesEvent(call:String, un:String="", pw:String="",
                                           rn:String="", added:String='',
                                           with_grant:String='') {
            DebugWindow.log("UsersAndRolesEvent.as");
            super(USERSANDROLES);
            
            this.call = call;
            user = un;
            pass = pw;
            role_name = rn;
            this.added = added;
            this.with_grant = with_grant;
        }
    }
}
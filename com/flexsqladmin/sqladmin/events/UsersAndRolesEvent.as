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
        public var perms_list:Array;

        public function UsersAndRolesEvent(call:String, un:String="", pw:String="",
                                           rn:String="", added:String='',
                                           with_grant:String='', perms_list:Array=null) {
            DebugWindow.log("UsersAndRolesEvent.as");
            super(USERSANDROLES);
            
            this.call = call;
            user = un;
            pass = pw;
            role_name = rn;
            this.added = added;
            this.with_grant = with_grant;
            this.perms_list = perms_list;
        }
    }
}
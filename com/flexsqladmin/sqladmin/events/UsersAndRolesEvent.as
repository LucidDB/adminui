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

        public function UsersAndRolesEvent(call:String, un:String="", pw:String="") {
            DebugWindow.log("UsersAndRolesEvent.as");
            super(USERSANDROLES);
            
            this.call = call;
            user = un;
            pass = pw;
        }
    }
}
package com.flexsqladmin.sqladmin.events
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.utils.ActionEnum;
    
    public class UsersAndRolesEvent extends CairngormEvent {
        public static var USERSANDROLES:String = "usersandroles";
        
        public var call:String;

        public function UsersAndRolesEvent(call:String) {
            DebugWindow.log("UsersAndRolesEvent.as");
            super(USERSANDROLES);
            
            this.call = call;
        }
    }
}
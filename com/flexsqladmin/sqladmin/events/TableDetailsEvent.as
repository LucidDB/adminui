package com.flexsqladmin.sqladmin.events
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    
    public class TableDetailsEvent extends CairngormEvent {
        public static var TABLEDETAILS:String = "tabledetails";

        public function TableDetailsEvent() {
            DebugWindow.log("TableDetailsEvent.as");
            super(TABLEDETAILS);
        }
    }
}
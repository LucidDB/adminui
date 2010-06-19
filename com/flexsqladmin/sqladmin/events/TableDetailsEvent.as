package com.flexsqladmin.sqladmin.events
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.utils.ActionEnum;
    
    public class TableDetailsEvent extends CairngormEvent {
        public static var TABLEDETAILS:String = "tabledetails";
        
        public var catalog:String;
        public var schema:String;
        public var table:String;
        public var action:ActionEnum;

        public function TableDetailsEvent(cat:String, sch:String, tab:String, act:ActionEnum) {
            DebugWindow.log("TableDetailsEvent.as");
            super(TABLEDETAILS);
            
            catalog = cat;
            schema = sch;
            table = tab;
            action = act;
        }
    }
}
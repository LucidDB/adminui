package com.flexsqladmin.sqladmin.commands
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.commands.Command;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.flexsqladmin.sqladmin.business.GeneralDelegate;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.events.GeneralServiceEvent;
    import com.flexsqladmin.sqladmin.model.ModelLocator;
    
    public class GenerateDdlCommand implements Command, Responder {
        private var model:ModelLocator = ModelLocator.getInstance();
        private var args:Object;
        private var extra_args:Object;
        
        public function execute(event:CairngormEvent) : void {
            DebugWindow.log("GenderateDdlCommand:execute()");
            var service_call:String = GeneralServiceEvent(event).service_call;
            args = GeneralServiceEvent(event).args;
            extra_args = GeneralServiceEvent(event).extra_args;
            
            var delegate:GeneralDelegate = new GeneralDelegate(this, 'sqlWebService');
            
            delegate.serviceDelegate(service_call, GeneralServiceEvent(event).args);
        }
        
        public function onResult(event:*=null) : void {
            var stmt:String = String(XML(event.result));
            model.object_tree.script_query(stmt, args['schema']);
        }
        
        public function onFault(event:*=null) : void {
            DebugWindow.log("GenerateDdlCommand.as:onFault()");
        }
    }
}
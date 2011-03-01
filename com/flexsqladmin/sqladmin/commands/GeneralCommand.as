package com.flexsqladmin.sqladmin.commands
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.commands.Command;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.flexsqladmin.sqladmin.business.GeneralDelegate;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.events.GeneralServiceEvent;
    
    import mx.managers.CursorManager;
    
    public class GeneralCommand implements Command, Responder {
        private var args:Object;
        private var extra_args:Object;
        
        public function execute(event:CairngormEvent) : void {
            DebugWindow.log("GeneralCommand:execute()");
            var service_call:String = GeneralServiceEvent(event).service_call;
            var service:String = GeneralServiceEvent(event).service;
            args = GeneralServiceEvent(event).args;
            extra_args = GeneralServiceEvent(event).extra_args;
            
            CursorManager.setBusyCursor();
            var delegate:GeneralDelegate = new GeneralDelegate(this, service);
            delegate.serviceDelegate(service_call, GeneralServiceEvent(event).args);
        }
        
        public function onResult(event:*=null) : void {
            CursorManager.removeBusyCursor();
            if (extra_args && extra_args.hasOwnProperty('callback')) {
                if (extra_args.hasOwnProperty('callback_arg')) {
                    extra_args['callback'](event.result, extra_args['callback_arg']);
                } else {
                    extra_args['callback'](event.result);
                }
            }
        }
        
        public function onFault(event:*=null) : void {
            CursorManager.removeBusyCursor();
            DebugWindow.log("GeneralCommand.as:onFault()");
        }
    }
}
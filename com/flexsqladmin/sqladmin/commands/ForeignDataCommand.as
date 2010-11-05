package com.flexsqladmin.sqladmin.commands
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.commands.Command;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.flexsqladmin.sqladmin.business.GeneralDelegate;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.events.GeneralServiceEvent;
    
    import mx.controls.Alert;
    
    public class ForeignDataCommand implements Command, Responder {
        
        private var args:Object;
        private var extra_args:Object;
        
        public function execute(event:CairngormEvent) : void {
            DebugWindow.log("ForeignDataCommand:execute()");
            var service_call:String = GeneralServiceEvent(event).service_call;
            args = GeneralServiceEvent(event).args;
            //if (args.hasOwnProperty('options'))
            //    trace(XMLList(args.options).toXMLString());
            extra_args = GeneralServiceEvent(event).extra_args;
            
            var delegate:GeneralDelegate = new GeneralDelegate(this, 'ForeignDataService');
            
            delegate.serviceDelegate(service_call, GeneralServiceEvent(event).args);
        }
        
        public function onResult(event:*=null) : void {
            if (extra_args && extra_args.hasOwnProperty('callback')) {
                if (extra_args.hasOwnProperty('callback_arg')) {
                    extra_args['callback'](event.result, extra_args['callback_arg']);
                } else {
                    extra_args['callback'](event.result);
                }
                return;
            }
        }
        
        public function onFault(event:*=null) : void {
            DebugWindow.log("ForeignDataCommand.as:onFault()");
        }
    }
}
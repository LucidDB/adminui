package com.dynamobi.adminui.events
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.dynamobi.adminui.components.DebugWindow;
    import com.dynamobi.adminui.control.Controller;
    
    public dynamic class GeneralServiceEvent extends CairngormEvent {
        

        // Used for the cairgngorm controller to map events to command classes.
        private static var command_calls:Array = [];
        
        /**
        * @param command_class - Some class in the commands directory.
        * @param service_call - The name of the service we want to call.
        * @param args - Arguments to the service.
        * @param extra_args - Extra args we want the command class to know about.
        */
        public function GeneralServiceEvent(command_class:Class, service_call:String,
                                            args:Object, extra_args:Object = null, service:String=null) {
            super(command_class.toString());

            for (var arg_name:String in args) {
                this[arg_name] = args[arg_name];
            }
            for (arg_name in extra_args) {
                this[arg_name] = extra_args[arg_name];
            }
            this['service_call'] = service_call;
            this['args'] = args;
            this['extra_args'] = extra_args;
            this['service'] = service;
       
            for (var i:Number = 0; i < command_calls.length; i++) {
                if (command_calls[i] == command_class.toString())
                    return;
            }
            Controller.getInstance().addCommand(command_class.toString(), command_class);
            command_calls.push(command_class.toString());
        }
        
    }
}
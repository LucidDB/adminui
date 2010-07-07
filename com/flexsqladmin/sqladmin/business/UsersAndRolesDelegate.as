package com.flexsqladmin.sqladmin.business
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.business.ServiceLocator;
    import com.flexsqladmin.sqladmin.business.Services;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.model.ModelLocator;
    
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    
    import mx.rpc.AbstractOperation;
    import mx.rpc.AsyncToken;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.soap.mxml.WebService;
    
    public class UsersAndRolesDelegate {
        private var responder:Responder;
        private var service:WebService;
        
        private var model:ModelLocator = ModelLocator.getInstance();
        
        public function UsersAndRolesDelegate(r:Responder) {
            DebugWindow.log("UsersAndRolesDelegate.as:UsersAndRolesDelegate()");
            service = ServiceLocator.getInstance().getService("UsersAndRolesService") as WebService;
            model.tempConnectionVO.setHttpHeaders(service);
            responder = r;
        }
        
        public function serviceDelegate(operation:String, arguments:Object=null) : void {
            var o:AbstractOperation = service.getOperation(operation);
            if (arguments) {
                for (var arg:String in arguments) {
                    if (arguments[arg])
                        o.arguments[arg] = arguments[arg];
                }
            }
            // We should be able to do this:
            //var token:AsyncToken = service[operation]();
            // But unfortunately the WebService interface overrides this functionality,
            // so we have to do this verbose thing to dynamically call.
            var token:AsyncToken = flash.utils.Proxy(service).flash_proxy::callProperty.apply(service, [operation]);
            token.resultHandler = responder.onResult;
            token.faultHandler = responder.onFault;
        }
        
    }
}
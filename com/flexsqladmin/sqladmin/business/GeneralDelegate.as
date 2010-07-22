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
    
    public class GeneralDelegate
    {
        private var responder:Responder;
        private var service:WebService;
        
        private var model:ModelLocator = ModelLocator.getInstance();
        
        public function GeneralDelegate(r:Responder, service_name:String) {
            DebugWindow.log("GeneralDelegate.as:GeneralDelegate()");
            this.service = ServiceLocator.getInstance().getService(service_name) as WebService;
            model.tempConnectionVO.setHttpHeaders(this.service);
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
            var token:AsyncToken = flash.utils.Proxy(service).flash_proxy::callProperty.apply(service, [operation]);
            token.resultHandler = responder.onResult;
            token.faultHandler = responder.onFault;
        }
  
    }
}
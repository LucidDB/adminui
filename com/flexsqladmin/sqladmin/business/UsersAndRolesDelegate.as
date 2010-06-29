package com.flexsqladmin.sqladmin.business
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.business.ServiceLocator;
    import com.flexsqladmin.sqladmin.business.Services;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.model.ModelLocator;
    
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
            //service.showBusyCursor = false;
            model.tempConnectionVO.setHttpHeaders(service);
            responder = r;
        }
        
        public function getCurrentSessions() : void {
            var o:AbstractOperation = service.getOperation("getCurrentSessions");
            var token:AsyncToken = service.getCurrentSessions();
            token.resultHandler = responder.onResult;
            token.faultHandler = responder.onFault;
        }
        
        public function getUsersDetails() : void {
            service.showBusyCursor = true;
            var o:AbstractOperation = service.getOperation("getUsersDetails");
            var token:AsyncToken = service.getUsersDetails();
            token.resultHandler = responder.onResult;
            token.faultHandler = responder.onFault;
        }
        
    }
}
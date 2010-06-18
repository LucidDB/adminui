package com.flexsqladmin.sqladmin.business
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.business.ServiceLocator;
    import com.flexsqladmin.sqladmin.commands.TableDetailsCommand;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.vo.TableDetailsVO;
    import com.flexsqladmin.sqladmin.model.ModelLocator;
    
    import mx.rpc.AbstractOperation;
    import mx.rpc.AsyncToken;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.soap.mxml.WebService;

   public class getTableDetailsDelegate
    {

       private var responder:Responder;
       private var service:WebService;

       private var model:ModelLocator = ModelLocator.getInstance();
       
       public function getTableDetailsDelegate(r:Responder) {
           DebugWindow.log("getTableDetailsDelegate.as:getTableDetailsDelegate()");
           service = ServiceLocator.getInstance().getService("TableDetailsService") as WebService;
           model.tempConnectionVO.setHttpHeaders(service);
           responder = r;
       }
        
       public function getTableDetails(cat:String, schema:String, table:String) : void {
           DebugWindow.log("getTableDetailsDelegate.as:getTableDetails()");
           var o:AbstractOperation = service.getOperation("getTableDetails");
           o.arguments.table = table;
           o.arguments.schema = schema;
           o.arguments.catalog = cat;
           var token:AsyncToken = service.getTableDetails();
           token.resultHandler = responder.onResult;
           token.faultHandler = responder.onFault;
       }
       
       public function getTableDetails_onResult(event:ResultEvent) : void {
           DebugWindow.log("getTableDetails.as:getTableDetails_onResult()");
           responder.onResult(new ResultEvent(ResultEvent.RESULT, false, true));
       }
       
       public function getTableDetails_onFault(event:FaultEvent) : void {
           DebugWindow.log("getTableDetails.as:getTableDetails_onFault()");
       }   
   }
}
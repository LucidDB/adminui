package com.flexsqladmin.sqladmin.business
{
	import mx.controls.Alert;
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.adobe.cairngorm.business.Responder;
	import com.flexsqladmin.sqladmin.vo.ConnectionVO;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	
	public class handleUpdateDelegate
	{
		private var responder:Responder;
        private var service:WebService;
        
        public function handleUpdateDelegate(r:Responder)
        {
        	DebugWindow.log("handleUpdateDelegate.as:handleUpdateDelegate()");
            service = ServiceLocator.getInstance().getService("sqlWebService") as WebService;
            responder = r;
        }
        
        public function handleUpdate(sql:String, testsql:String, connectionVO:ConnectionVO):void
        {
        	DebugWindow.log("handleUpdateDelegate.as:handleUpdate('" + sql + "', '" + testsql + "')");
			var o:AbstractOperation = service.getOperation("handleUpdate");
			o.arguments.connection = connectionVO.getConnectionString();
			o.arguments.testsql = testsql;
			o.arguments.sql = sql;
			o.arguments.toomany = connectionVO.toomany;
			var token:AsyncToken = service.handleUpdate();
			token.resultHandler = responder.onResult;
			token.faultHandler = responder.onFault;
        }
        
        public function handleUpdate_onResult(event:ResultEvent):void
		{
			DebugWindow.log("handleUpdateDelegate.as:handleUpdate_onResult()");
			//DebugWindow.log("Web Service Result\n" + event.result.toString());
			responder.onResult(new ResultEvent(ResultEvent.RESULT, false, true));
		}
		
		public function handleUpdate_onFault(event:FaultEvent):void
		{
			DebugWindow.log("execSQLDelegate.as:handleUpdate_onFault()");
			//DebugWindow.log("Web Service Result\n" + event.toString());
		}
	}
}
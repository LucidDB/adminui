package com.flexsqladmin.sqladmin.business
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.vo.ConnectionVO;
	
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;
	
	public class getDBMetaDataDelegate
	{
		private var responder:Responder;
        private var service:WebService;
        
        public function getDBMetaDataDelegate(r:Responder)
        {
        	DebugWindow.log("getDBMetaDataDelegate.as:getDBMetaDataDelegate()");
            service = ServiceLocator.getInstance().getService("sqlWebService") as WebService;
            responder = r;
        }
        
        public function getDBMetaData(s:String,connectionVO:ConnectionVO):void
        {
        	DebugWindow.log("getDBMetaDataDelegate.as:getDBMetaData()");
			var o:AbstractOperation = service.getOperation("getDBMetaData");
//			o.arguments.connection = connectionVO.getConnectionString();
            o.arguments.connection = "";
            o.arguments.schema = s;
			var token:AsyncToken = service.getDBMetaData();
			token.resultHandler = responder.onResult;
			token.faultHandler = responder.onFault;
        }
        
        public function getDBMetaData_onResult(event:ResultEvent):void
		{
			DebugWindow.log("getDBMetaDataDelegate.as:getDBMetaData_onResult()");
			DebugWindow.log("Web Service Result\n" + event.result.toString());
			responder.onResult(new ResultEvent(ResultEvent.RESULT, false, true));
		}
		
		public function getDBMetaData_onFault(event:FaultEvent):void
		{
			DebugWindow.log("getDBMetaDataDelegate.as:getDBMetaData_onFault()");
			DebugWindow.log("Web Service Result\n" + event.toString());
		}
	}
}
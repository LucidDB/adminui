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
	import mx.utils.Base64Encoder;
	import com.flexsqladmin.sqladmin.model.ModelLocator;

	public class execSQLDelegate
	{
		private var responder:Responder;
        private var service:WebService;
        
        private var model:ModelLocator = ModelLocator.getInstance();
        
        public function execSQLDelegate(r:Responder)
        {
        	DebugWindow.log("execSQLDelegate.as:execSQLDelegate()");
            service = ServiceLocator.getInstance().getService("sqlWebService") as WebService;
            
            // Encode creds
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.insertNewLines = false;
			encoder.encode(model.tempConnectionVO.username+":"+ model.tempConnectionVO.password);			
			// Set creds on proxy
			service.httpHeaders = {"Authorization" : "Basic " + encoder.toString()};
            responder = r;
        }
        
        public function execSQL(sql:String, sqlquerytype:String, connectionVO:ConnectionVO):void
        {
        	DebugWindow.log("execSQLDelegate.as:execSQL('" + sql + "', '" + sqlquerytype + "', '" + connectionVO.getConnectionString() + "')");
			var o:AbstractOperation = service.getOperation("execSQL");
			o.arguments.connection = connectionVO.getConnectionString();
			o.arguments.sqlquerytype = sqlquerytype;
			o.arguments.sql = sql;
			o.arguments.toomany = connectionVO.toomany;
			var token:AsyncToken = service.execSQL();
			token.resultHandler = responder.onResult;
			token.faultHandler = responder.onFault;
        }
        
        public function execSQL_onResult(event:ResultEvent):void
		{
			DebugWindow.log("execSQLDelegate.as:execSQL_onResult()");
			//Use firebug for this. //DebugWindow.log("Web Service Result\n" + event.result.toString());
			responder.onResult(new ResultEvent(ResultEvent.RESULT, false, true));
		}
		
		public function execSQL_onFault(event:FaultEvent):void
		{
			DebugWindow.log("execSQLDelegate.as:execSQL_onFault()");
			//DebugWindow.log("Web Service Result\n" + event.toString());
		}
	}
}
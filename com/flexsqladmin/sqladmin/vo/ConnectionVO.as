package com.flexsqladmin.sqladmin.vo
{
	import com.adobe.cairngorm.vo.ValueObject;
	
	[Bindable]
	public class ConnectionVO implements ValueObject
	{
        import mx.rpc.soap.mxml.WebService;
        import mx.utils.Base64Encoder;

		public var username:String = "";
		public var password:String = "";
		public var server:String = "";
		public var database:String = "";
		public var toomany:Number = 5000;
		public var dbtype:String = "MSSQL";
		
		public function getConnectionString():String{
			return "server=" + server + ";uid=" + username + ";pwd=" + password + ";database=" + database;
		}
        
        public function setHttpHeaders(service : WebService) : void {
            // Encode creds
            var encoder:Base64Encoder = new Base64Encoder();
            encoder.insertNewLines = false;
            encoder.encode(username + ":" + password);			
            // Set creds on proxy
            service.httpHeaders = {"Authorization" : "Basic " + encoder.toString()};
        }
		
	}
}
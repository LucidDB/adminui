/*
Copyright 2006-2010 Kevin Kazmierczak. All rights reserved.
Copyright 2010 Dynamo Business Intelligence Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY Dynamo Business Intelligence Corporation ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Dynamo Business Intelligence Corporation OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
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
/*
Dynamo Admin UI is a web service project for administering LucidDB
Copyright (C) 2010 Dynamo Business Intelligence Corporation

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option)
any later version approved by Dynamo Business Intelligence Corporation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
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
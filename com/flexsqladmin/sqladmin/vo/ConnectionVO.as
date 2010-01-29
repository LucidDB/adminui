package com.flexsqladmin.sqladmin.vo
{
	import com.adobe.cairngorm.vo.ValueObject;
	
	[Bindable]
	public class ConnectionVO implements ValueObject
	{
		public var username:String = "";
		public var password:String = "";
		public var server:String = "";
		public var database:String = "";
		public var toomany:Number = 5000;
		public var dbtype:String = "MSSQL";
		
		public function getConnectionString():String{
			return "server=" + server + ";uid=" + username + ";pwd=" + password + ";database=" + database;
		}
		
	}
}
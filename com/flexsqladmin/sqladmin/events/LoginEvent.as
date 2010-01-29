package com.flexsqladmin.sqladmin.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flexsqladmin.sqladmin.view.LoginWindow;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	
	public class LoginEvent extends CairngormEvent
	{
		
		public var sql:String = "";
		public var sqlquerytype:String = "";
		public var loginWindow:LoginWindow;
		
		public static var LOGIN:String = "login";
		
		public function LoginEvent(s:String, sqt:String, lw:LoginWindow)
		{
			DebugWindow.log("LoginEvent.as:LoginEvent('" + s + "', '" + sqt + "')");
			super(LOGIN);
			sql = s; 
			sqlquerytype = sqt;
			loginWindow = lw;
		}
		
	}
}
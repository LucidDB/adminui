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
package com.dynamobi.adminui.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.dynamobi.adminui.view.LoginWindow;
	import com.dynamobi.adminui.components.DebugWindow;
	
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
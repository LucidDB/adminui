package com.flexsqladmin.sqladmin.commands
{
	import flash.events.Event;
	import mx.controls.Alert;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flexsqladmin.sqladmin.business.execSQLDelegate;
	import com.flexsqladmin.sqladmin.events.LoginEvent;
	import com.flexsqladmin.sqladmin.events.MetaDataEvent;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.view.LoginWindow;
	import com.flexsqladmin.sqladmin.vo.ConnectionVO;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	
	public class LoginCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		private var loginWindow:LoginWindow;
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("LoginCommand:execute()");
			loginWindow = LoginEvent(event).loginWindow;
			var sql:String = LoginEvent(event).sql;
			var sqlquerytype:String = LoginEvent(event).sqlquerytype;
			var delegate:execSQLDelegate = new execSQLDelegate(this);
			delegate.execSQL(sql, sqlquerytype, model.tempConnectionVO);
		}
		public function login():void{
			DebugWindow.log("LoginCommand:login()");
		}
		public function onResult(event:*=null):void
		{
			DebugWindow.log("LoginCommand:onResult()");
			DebugWindow.log("Web Service Result\n" + event.result.toString());
			var r:XML = new XML(event.result);
    		if(r.datamap == "Error"){
    			var errormsg:String = r.NewDataSet.Table.Error;
    			DebugWindow.log("Error - " + errormsg.substr(23, errormsg.length));
    			mx.controls.Alert.show(errormsg.substr(23, errormsg.length), "Login Error");
    			loginWindow.loginbtn.enabled = true;
    		} else {
    			DebugWindow.log("Connection Success");
    			loginWindow.closeWin(new Event(""));
    			
    			//Set Connection Live
    			model.connectionVO.username = model.tempConnectionVO.username;
    			model.connectionVO.password = model.tempConnectionVO.password;
    			model.connectionVO.server = model.tempConnectionVO.server;
    			model.connectionVO.database = model.tempConnectionVO.database;
    			model.connectionVO.toomany = model.tempConnectionVO.toomany;
				model.connectionText = "Connected to " + model.connectionVO.server + " as " + model.connectionVO.username + " using database " + model.connectionVO.database;
						
    			var metaevent:MetaDataEvent = new MetaDataEvent();
            	CairngormEventDispatcher.getInstance().dispatchEvent(metaevent);
    		}
		}
		public function onFault(event:*=null):void
		{
			DebugWindow.log("LoginCommand:onFault()");
		}
	}
}
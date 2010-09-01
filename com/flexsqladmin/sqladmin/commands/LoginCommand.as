/*
Copyright 2006-2010 Kevin Kazmierczak. All rights reserved.
Copyright 2010 Dynamo Business Intelligence Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY Dynamo Business Intelligence Corporation ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Dynamo Business Intelligence Corporation OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.flexsqladmin.sqladmin.business.GeneralDelegate;
	import com.flexsqladmin.sqladmin.components.DebugWindow;
	import com.flexsqladmin.sqladmin.events.ListCatalogsEvent;
	import com.flexsqladmin.sqladmin.events.LoginEvent;
	import com.flexsqladmin.sqladmin.events.MetaDataEvent;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.view.LoginWindow;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.ListEvent;
	
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
            
            var delegate:GeneralDelegate = new GeneralDelegate(this, "sqlWebService");
            var args:Object = {connection: model.connectionVO.getConnectionString(),
                sqlquerytype: sqlquerytype,
                sql: sql,
                toomany: model.connectionVO.toomany
            };
            delegate.serviceDelegate("execSQL", args);
		}
		public function login():void{
			DebugWindow.log("LoginCommand:login()");
		}
		public function onResult(event:*=null):void
		{
			DebugWindow.log("LoginCommand:onResult()");
			//DebugWindow.log("Web Service Result\n" + event.result.toString());
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
				model.connectionText = "Connected to " + model.connectionVO.server + " as " + model.connectionVO.username;
				
				var listcatalogsevent :ListCatalogsEvent= new ListCatalogsEvent();	
				CairngormEventDispatcher.getInstance().dispatchEvent(listcatalogsevent);
				
                // TODO: start migrating metadata out of everything, using the tree instead if necessary.
                // Quick fix: bind metadata to the tree, commented out the MeataDataCommand on result
                // that reassigns metadata.
                BindingUtils.bindProperty(model, 'metadata', model.object_tree, 'tree_data');
                model.object_tree.validateNow();
                model.object_tree.expandItem(model.object_tree.tree_data..schemas[0], true, true);
    		}
		}
		public function onFault(event:*=null):void
		{
			DebugWindow.log("LoginCommand:onFault()");
		    mx.controls.Alert.show("User is not available", "Login Error");
    		loginWindow.loginbtn.enabled = true;
		}
	}
}
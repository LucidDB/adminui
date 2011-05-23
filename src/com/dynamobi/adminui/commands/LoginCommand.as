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
package com.dynamobi.adminui.commands
{
	import com.adobe.cairngorm.business.Responder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.dynamobi.adminui.business.GeneralDelegate;
	import com.dynamobi.adminui.business.Services;
	import com.dynamobi.adminui.components.DebugWindow;
	import com.dynamobi.adminui.events.ListCatalogsEvent;
	import com.dynamobi.adminui.events.LoginEvent;
	import com.dynamobi.adminui.events.MetaDataEvent;
	import com.dynamobi.adminui.model.ModelLocator;
	import com.dynamobi.adminui.view.LoginWindow;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	
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
            var args:Object = {connection: model.tempConnectionVO.getConnectionString(),
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
    			mx.controls.Alert.show(errormsg.substr(23, errormsg.length), "Login Error").addEventListener(
                    Event.REMOVED, function(event:*) : void { loginWindow.loginbtn.enabled = true; });
    		} else {
    			DebugWindow.log("Connection Success");
    			loginWindow.closeWin(new Event(""));
    			
    			//Set Connection Live
    			model.connectionVO.username = model.tempConnectionVO.username;
    			model.connectionVO.password = model.tempConnectionVO.password;
                model.connectionVO.salt = model.tempConnectionVO.salt;
                model.connectionVO.uuid = model.tempConnectionVO.uuid;
                if (model.tempConnectionVO.server == '')
                    model.tempConnectionVO.server = 'localhost';
    			model.connectionVO.server = model.tempConnectionVO.server;
    			model.connectionVO.database = model.tempConnectionVO.database;
    			model.connectionVO.toomany = model.tempConnectionVO.toomany;
                model.connectionVO.raw_pass = model.tempConnectionVO.raw_pass;
                model.connectionVO.send_raw = false;
                model.tempConnectionVO.send_raw = false;
				//model.connectionText = "Connected to " + model.connectionVO.server + " as " + model.connectionVO.username;
				model.connectionText = 'Connected as ' + model.connectionVO.username;
                
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
            PopUpManager.removePopUp(Services.service_fault_alert);
		    mx.controls.Alert.show("Incorrect username or password--" +
                "if you believe you received this message in error, try restarting " +
                "LucidDB and/or the AdminUI Server.", "Login Error").addEventListener(
                    Event.REMOVED, function(event:*) : void { loginWindow.loginbtn.enabled = true; });
		}
	}
}
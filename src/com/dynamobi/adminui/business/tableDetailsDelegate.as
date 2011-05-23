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
package com.dynamobi.adminui.business
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.business.ServiceLocator;
    import com.dynamobi.adminui.business.Services;
    import com.dynamobi.adminui.commands.TableDetailsCommand;
    import com.dynamobi.adminui.components.DebugWindow;
    import com.dynamobi.adminui.model.ModelLocator;
    
    import mx.rpc.AbstractOperation;
    import mx.rpc.AsyncToken;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.soap.mxml.WebService;

   public class tableDetailsDelegate
    {

       private var responder:Responder;
       private var service:WebService;

       private var model:ModelLocator = ModelLocator.getInstance();
       
       public function tableDetailsDelegate(r:Responder) {
           DebugWindow.log("tableDetailsDelegate.as:tableDetailsDelegate()");
           service = ServiceLocator.getInstance().getService("TableDetailsService") as WebService;
           model.tempConnectionVO.setHttpHeaders(service);
           responder = r;
       }
        
       public function getTableDetails(cat:String, schema:String, table:String) : void {
           DebugWindow.log("tableDetailsDelegate.as:getTableDetails()");
           var o:AbstractOperation = service.getOperation("getTableDetails");
           o.arguments.table = table;
           o.arguments.schema = schema;
           o.arguments.catalog = cat;
           var token:AsyncToken = service.getTableDetails();
           token.resultHandler = responder.onResult;
           token.faultHandler = responder.onFault;
       }
       
       public function postTableDetails(cat:String, schema:String, table:String, details:XML) : void {
           // TODO: get rid of the hardcoded url in here.
           DebugWindow.log("tableDetailsDelegate.as:postTableDetails()");
           service.postTableDetails.request = XMLList(
               "<ns0:postTableDetails xmlns:ns0=\"http://api.ws.dynamobi.com/\">" +
               "<catalog>" + cat + "</catalog>" +
               "<schema>" + schema + "</schema>" +
               "<table>" + table + "</table>" +
               details +
               "</ns0:postTableDetails>"
               );
           var o:AbstractOperation = service.getOperation("postTableDetails");
           var token:AsyncToken = service.postTableDetails();
           token.resultHandler = responder.onResult;
           token.faultHandler = responder.onFault;
       }
       
       public function createSchema(cat:String, schema:String) : void {
           DebugWindow.log("tableDetailsDelegate.as:createSchema()");
           var o:AbstractOperation = service.getOperation("createSchema");
           o.arguments.schema = schema;
           o.arguments.catalog = cat;
           var token:AsyncToken = service.createSchema();
           token.resultHandler = responder.onResult;
           token.faultHandler = responder.onFault;
       }
   
   }
}
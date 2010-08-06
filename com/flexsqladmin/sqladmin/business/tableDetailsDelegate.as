/*
Copyright 2010 Dynamo Business Intelligence Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY Dynamo Business Intelligence Corporation ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Dynamo Business Intelligence Corporation OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.flexsqladmin.sqladmin.business
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.business.ServiceLocator;
    import com.flexsqladmin.sqladmin.business.Services;
    import com.flexsqladmin.sqladmin.commands.TableDetailsCommand;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.model.ModelLocator;
    
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
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
    import com.dynamobi.adminui.components.DebugWindow;
    import com.dynamobi.adminui.model.ModelLocator;
    
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;
    
    import mx.rpc.AbstractOperation;
    import mx.rpc.AsyncToken;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.soap.mxml.WebService;
    import mx.utils.ObjectUtil;
    
    public class GeneralDelegate
    {
        private var responder:Responder;
        private var service:WebService;
        
        private var model:ModelLocator = ModelLocator.getInstance();
        
        public function GeneralDelegate(r:Responder, service_name:String) {
            DebugWindow.log("GeneralDelegate.as:GeneralDelegate()-"+service_name);
            this.service = ServiceLocator.getInstance().getService(service_name) as WebService;
            model.tempConnectionVO.setHttpHeaders(this.service);
            responder = r;
        }
        
        public function serviceDelegate(operation:String, arguments:Object=null) : void {
            DebugWindow.log('GeneralDelegate.as:serviceDelegate(' + operation + ', ' +
                mx.utils.ObjectUtil.toString(arguments) + ')');
            var o:AbstractOperation = service.getOperation(operation);
            if (arguments) {
                for (var arg:String in arguments) {
                    if (arguments[arg])
                        o.arguments[arg] = arguments[arg];
                }
            }
            var token:AsyncToken = flash.utils.Proxy(service).flash_proxy::callProperty.apply(service, [operation]);
            token.resultHandler = responder.onResult;
            token.faultHandler = responder.onFault;
        }
  
    }
}
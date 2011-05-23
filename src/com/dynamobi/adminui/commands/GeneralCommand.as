/*
Dynamo Admin UI is a web service project for administering LucidDB
Copyright (C) 2011 Dynamo Business Intelligence Corporation

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
package com.flexsqladmin.sqladmin.commands
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.commands.Command;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.flexsqladmin.sqladmin.business.GeneralDelegate;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.events.GeneralServiceEvent;
    
    import mx.managers.CursorManager;
    
    public class GeneralCommand implements Command, Responder {
        private var args:Object;
        private var extra_args:Object;
        
        public function execute(event:CairngormEvent) : void {
            DebugWindow.log("GeneralCommand:execute()");
            var service_call:String = GeneralServiceEvent(event).service_call;
            var service:String = GeneralServiceEvent(event).service;
            args = GeneralServiceEvent(event).args;
            extra_args = GeneralServiceEvent(event).extra_args;
            
            CursorManager.setBusyCursor();
            var delegate:GeneralDelegate = new GeneralDelegate(this, service);
            delegate.serviceDelegate(service_call, GeneralServiceEvent(event).args);
        }
        
        public function onResult(event:*=null) : void {
            CursorManager.removeBusyCursor();
            if (extra_args && extra_args.hasOwnProperty('callback')) {
                if (extra_args.hasOwnProperty('callback_arg')) {
                    extra_args['callback'](event.result, extra_args['callback_arg']);
                } else {
                    extra_args['callback'](event.result);
                }
            }
        }
        
        public function onFault(event:*=null) : void {
            CursorManager.removeBusyCursor();
            DebugWindow.log("GeneralCommand.as:onFault()");
        }
    }
}
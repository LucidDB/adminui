/*
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
    import com.flexsqladmin.sqladmin.business.GeneralDelegate;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.events.ObjectTreeLoaderEvent;

    public class ObjectTreeLoaderCommand implements Command, Responder {
        public function ObjectTreeLoaderCommand() {
            
        }
        
        //private var model:ModelLocator = ModelLocator.getInstance();
        //private var request_type:ActionEnum;
        
        private var loadInfo:Object;
        private var parent:XML;

        public function execute(event:CairngormEvent) : void {
            DebugWindow.log("ObjectTreeLoaderCommand:execute()");
            loadInfo = ObjectTreeLoaderEvent(event).loadInfo;
            parent = ObjectTreeLoaderEvent(event).parentNode;
            
            var delegate:GeneralDelegate = new GeneralDelegate(this, loadInfo.service);
            delegate.serviceDelegate(loadInfo.operation, loadInfo.arguments);
        }
        
        public function onResult(event:*=null) : void {
            var children:XMLList = parent.children();
            var num:Number = children.length();
            parent.appendChild(new XML(event.result).children());
            // Delete after to prevent a second load during the brief period length becomes 0.
            for (var i:Number = 0; i < num; i++) {
                delete children[i];
            }
            /*var r:XML = new XML(event.result);
            if(r.datamap == "Error"){
                var errormsg:String = r.NewDataSet.Table.Error;
                DebugWindow.log("Error - " + errormsg);
            } else {
                model.table_details[VBox(model.main_tabnav.selectedChild).id].details = new XML(XML(event.result['return']));
                CreateEditTableWindow(VBox(model.main_tabnav.selectedChild).getChildAt(0)).addColumnsFromDetails();
            } */           
        }
        
        public function onFault(event:*=null) : void {
            DebugWindow.log("ObjectTreeLoaderCommand:onFault()");
        }
    }
}
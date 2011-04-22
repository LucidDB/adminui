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
package com.flexsqladmin.sqladmin.commands
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.commands.Command;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.flexsqladmin.sqladmin.business.GeneralDelegate;
    import com.flexsqladmin.sqladmin.components.DebugWindow;
    import com.flexsqladmin.sqladmin.events.ObjectTreeLoaderEvent;
    import com.flexsqladmin.sqladmin.model.ModelLocator;

    public class ObjectTreeLoaderCommand implements Command, Responder {
        public function ObjectTreeLoaderCommand() {
            
        }
        
        private var model:ModelLocator = ModelLocator.getInstance();
        
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
            var data:XML = XML(XML(event.result)['return'].@result.toString());
            if (!data || data.toXMLString() == "") {
                data = XML(event.result);
            }
            var children:XMLList = parent.children();
            var num:Number = children.length();
            parent.appendChild(data.children());
            // Were any children even added?
            if (data.children().length() == 0)
                parent.appendChild(<node label="Empty" />);

            // Delete after to prevent a second load during the brief period length becomes 0.
            for (var i:Number = 0; i < num; i++) {
                delete children[i];
            }
            if (loadInfo.hasOwnProperty('tree_callback')) {
                model.object_tree[loadInfo.tree_callback]();
            }
        }
        
        public function onFault(event:*=null) : void {
            DebugWindow.log("ObjectTreeLoaderCommand:onFault()");
        }
    }
}
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
package com.dynamobi.adminui.components
{
    import com.adobe.cairngorm.control.CairngormEventDispatcher;
    import com.adobe.serialization.json.JSON;
    import com.dynamobi.adminui.events.ObjectTreeLoaderEvent;
    
    import mx.collections.ICollectionView;
    import mx.collections.XMLListCollection;
    import mx.controls.treeClasses.ITreeDataDescriptor;
    
    public class ObjectTreeDataDescriptor implements ITreeDataDescriptor {
        
        public function ObjectTreeDataDescriptor() {
            //tree = new Object();
        }
        
        public function getChildren(node:Object, model:Object=null) : ICollectionView {
            // returns a xmllistcollection with child elements
            
            /*this.model = model;
            if (XML(node).localName() != 'loader') {
                return tree[node];
            } else {
                
            }*/
            if (XML(node).children().length() > 0) {
                return new XMLListCollection(XML(node).children());                
            }

            if (! XML(node).hasOwnProperty('@loadInfo')) {
                // It's a trap!
                throw new Error("Node claims to have children but contains a Loader and does not have XML" +
                    "attribute 'serviceCall' defined.");
            }
            
            // Need to begin loading the node(s) now.
            var info:Object = JSON.decode(XML(node).@loadInfo);
            var loader:XMLList = new XMLList(<loader label="Loading..." />);
            var loader_event:ObjectTreeLoaderEvent = new ObjectTreeLoaderEvent(info, node as XML);
            CairngormEventDispatcher.getInstance().dispatchEvent(loader_event);
            XML(node).appendChild(loader);
            return new XMLListCollection(loader);
        }
        
        public function hasChildren(node:Object, model:Object=null) : Boolean {
            if (XML(node).hasOwnProperty('@loadInfo') || (XML(node).localName() != 'loader' && XML(node).children().length() > 0)) {
                return true;
            } else {
                return false;
            }
        }
        
        public function isBranch(node:Object, model:Object=null) : Boolean {
            return hasChildren(node, model) || (XML(node).hasOwnProperty('@isBranch') && XML(node).@isBranch);
        }
        
        public function getData(node:Object, model:Object=null) : Object {
            return XML(node);
        }
        
        public function addChildAt(parent:Object, newChild:Object, index:int, model:Object=null) : Boolean {
            return false;
        }
        
        public function removeChildAt(parent:Object, child:Object, index:int, model:Object=null) : Boolean {
            return false;
        }
    }
}
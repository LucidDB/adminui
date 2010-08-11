/*
Copyright 2010 Dynamo Business Intelligence Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY Dynamo Business Intelligence Corporation ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Dynamo Business Intelligence Corporation OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.flexsqladmin.sqladmin.components
{
    import com.adobe.cairngorm.control.CairngormEventDispatcher;
    import com.adobe.serialization.json.JSON;
    import com.flexsqladmin.sqladmin.events.ObjectTreeLoaderEvent;
    
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
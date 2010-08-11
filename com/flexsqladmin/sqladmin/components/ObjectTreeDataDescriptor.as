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
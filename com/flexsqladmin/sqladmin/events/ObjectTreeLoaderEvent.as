package com.flexsqladmin.sqladmin.events
{
    import com.adobe.cairngorm.control.CairngormEvent;
    
    public class ObjectTreeLoaderEvent extends CairngormEvent {
        
        public static var OBJECT_TREE_LOADER:String = 'object_tree_loader';
        public var loadInfo:Object;
        public var parentNode:XML;

        public function ObjectTreeLoaderEvent(info:Object, parent:XML) {
            loadInfo = info;
            parentNode = parent;
            super(OBJECT_TREE_LOADER);
        }
    }
}
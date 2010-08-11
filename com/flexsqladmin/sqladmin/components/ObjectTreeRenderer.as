/*
Copyright 2010 Dynamo Business Intelligence Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY Dynamo Business Intelligence Corporation ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Dynamo Business Intelligence Corporation OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.flexsqladmin.sqladmin.components
{
    import flash.geom.Point;
    
    import mx.controls.treeClasses.TreeItemRenderer;
    
    public class ObjectTreeRenderer extends TreeItemRenderer {
        
        import com.flexsqladmin.sqladmin.utils.CustomFuncs;
        
        import mx.containers.HBox;
        import mx.controls.Image;
        import mx.controls.Label;
        import mx.controls.treeClasses.TreeListData;
        
        public var disBox:HBox;
        public var disLabel:Label;
        public var iconsBox:HBox;
        public var treeListData:TreeListData;
        public var firstgo:Boolean = true;
        
        // Todo: rename some of these icons to proper names.
        [Embed(source="/icons/database_schemas.png")]
        private var schemas_icon:Class;
        [Embed(source="/icons/database_schema.png")]
        private var schema_icon:Class;
        [Embed(source="/icons/table_multiple.png")]
        private var tables_icon:Class;
        [Embed(source="/icons/database.png")]
        private var table_icon:Class;
        [Embed(source="/icons/database_table.png")]
        private var column_icon:Class;
        [Embed(source="/icons/folder_user.png")]
        private var users_icon:Class;
        [Embed(source="/icons/group.png")]
        private var user_icon:Class;
        
        
        [Bindable]
        public var icons_list:Object = {
              'schemas' : schemas_icon
            , 'schema' : schema_icon
            , 'tables' : tables_icon
            , 'table' : table_icon
            , 'column' : column_icon
            , 'users' : users_icon
            , 'user' : user_icon
        }
            
        override protected function createChildren() : void {
            super.createChildren();
            if (firstgo) {
                for (var i:Number = 0; i < numChildren; i++) {
                    super.removeChildAt(i);
                }
                if (disBox == null) {
                    disBox = new HBox();
                    disLabel = new Label();
                    iconsBox = new HBox();

                    disBox.addChild(iconsBox);
                    disBox.addChild(disLabel);
                    this.addChild(disBox);
                }
                firstgo = false;
            }
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void {
            treeListData = TreeListData(listData);
            if (treeListData != null) {
                if (super.data) {
                    var node:XML = treeListData.item as XML;

                    iconsBox.removeAllChildren();
                    icon.visible = false;
                    if (node.hasOwnProperty('@icon_name') && icons_list.hasOwnProperty(node.@icon_name)) {
                        var ic:Image = new Image();
                        ic.source = icons_list[node.@icon_name];
                        iconsBox.addChild(ic);
                    } else if (icons_list.hasOwnProperty(node.localName())) {
                        ic = new Image();
                        ic.source = icons_list[node.localName()];
                        iconsBox.addChild(ic);
                    } else {
                        // default icon
                        icon.visible = true;
                    }
                    
                    disLabel.text = node.@label;
                    disLabel.percentWidth = 100;
                    
                    disBox.height = height;
                    disBox.width = width - (icon.width + icon.x) - icon.width + 16;
                    disBox.x = icon.x;
                    if (icon.visible)
                        disBox.x += icon.width;
                    disBox.visible = true;
                }
            }
            super.updateDisplayList(unscaledWidth, unscaledHeight);
        }
        
    }
}
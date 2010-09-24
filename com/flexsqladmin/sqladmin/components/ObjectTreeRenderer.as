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
        [Embed(source="/icons/scripts.png")]
        private var views_icon:Class;
        [Embed(source="/icons/script_select.png")]
        private var view_icon:Class;
        [Embed(source="/icons/database_table.png")]
        private var column_icon:Class;
        [Embed(source="/icons/folder_user.png")]
        private var users_icon:Class;
        [Embed(source="/icons/group.png")]
        private var user_icon:Class;
        [Embed(source="/icons/monitor.png")]
        private var system_icon:Class;
        [Embed(source="/icons/report.png")]
        private var counters_icon:Class;
        [Embed(source="/icons/report_user.png")]
        private var sessions_icon:Class;
        
        
        [Bindable]
        public var icons_list:Object = {
              'schemas' : schemas_icon
            , 'schema' : schema_icon
            , 'tables' : tables_icon
            , 'table' : table_icon
            , 'views' : views_icon
            , 'view' : view_icon
            , 'column' : column_icon
            , 'users' : users_icon
            , 'user' : user_icon
            , 'system' : system_icon
            , 'counters' : counters_icon
            , 'sessions' : sessions_icon
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

                    disBox.horizontalScrollPolicy = "off";
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
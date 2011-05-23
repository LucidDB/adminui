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
    import mx.binding.utils.BindingUtils;
    import mx.containers.FormItem;
    import mx.controls.Image;
    import mx.utils.StringUtil;
    
    public class FormItemWithImage extends FormItem {
        
        private var _image_source:Class = null;
        private var image:Image;
        private var _label:String;
        
        [Bindable]
        public override function get label() : String {
            return _label;
        }
        
        public override function set label(str:String) : void {
            if (_image_source != null) {
                _label = "    " + str;
            } else {
                _label = StringUtil.trim(str);
            }
            super.label = _label;
        }
        
        [Bindable]
        public function get imageSource() : Class {
            return _image_source;
        }
        
        public function set imageSource(src : Class) : void {
            _image_source = src;
            if (_image_source != null) {
                label = "    " + StringUtil.trim(_label);
            } else {
                label = StringUtil.trim(_label);
            }
        }
        
        public function FormItemWithImage() {
            super();
        }
        
        protected override function createChildren() : void {
            super.createChildren();
            image = new Image();
            image.width = 16;
            image.height = 16;
            image.source = _image_source;
            //image.setStyle("verticalCenter", 0);
            image.setStyle("left", 5);
            image.toolTip = StringUtil.trim(_label); 
            rawChildren.addChild(image);
            BindingUtils.bindProperty(image, 'source', this, 'imageSource');
        }
    }
}
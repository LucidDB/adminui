/*
Copyright 2010 Dynamo Business Intelligence Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY Dynamo Business Intelligence Corporation ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Dynamo Business Intelligence Corporation OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.flexsqladmin.sqladmin.components
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
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
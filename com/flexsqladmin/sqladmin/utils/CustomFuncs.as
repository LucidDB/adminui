package com.flexsqladmin.sqladmin.utils
{
    public final class CustomFuncs {
        public static function wordMult(word:String, times:Number) : String {
            // 'hello' * 2 = 'hellohello'
            // Note: the make array, push, push, array.join('') idiom is much slower in flex,
            // use simple string concatenation
            var new_word:String = word;
            while (times > 0) {
                new_word += word;
                times -= 1;
            }
            return new_word;
        }
        
        public static function htmlEntities(str:String) : String {
            var escaped:String = '';
            for (var i:Number = 0; i < str.length; ++i) {
                var c:String = str.charAt(i);
                if (c == '<')
                    escaped += '&lt;';
                else if (c == '>')
                    escaped += '&gt;';
                else if (c == '"')
                    escaped += '&quot;';
                else if (c == "'")
                    escaped += '&apos;';
                else if (c == '&')
                    escaped += '&amp;';
                else
                    escaped += c;
            }
            return escaped;
        }
        
        public static function colorInterpolate(col1:Array, col2:Array, factor:Number=0.5) : Array {
            var col_inter:Array = [
                (col2[0] - col1[0])*factor + col2[0],
                (col2[1] - col1[1])*factor + col2[1],
                (col2[2] - col1[2])*factor + col2[2]
                ];
            return col_inter;
        }
        
        public static function hexColorInterpolate(col1:Number, col2:Number, factor:Number=0.5) : Number {
            var c1:Array = [col1 & 0xff0000, col1 & 0x00ff00, col1 & 0x0000ff];
            var c2:Array = [col2 & 0xff0000, col2 & 0x00ff00, col2 & 0x0000ff];
            var inter:Array = colorInterpolate(c1, c2, factor);
            var col_inter:Number = (inter[0] << 16) | (inter[1] << 8) | inter[2];
            return col_inter;
        }
        
        
        // The following (XML) set functions are not implemented with efficiency in mind;
        // probably best not to use them for large sets.
        
        /**
         * @author Kevin Secretan
         * var l1:XMLList = new XMLList('<user name="bob" /><user grade="4" name="alice" /><user name="susie" />');
         * var l2:XMLList = new XMLList('<user name="alice" grade="4" /><user name="frank" />');
         * trace("diff: " + CustomFuncs.XMLdifference(l1, l2).toXMLString());
         * trace("union: " + CustomFuncs.XMLunion(l1, l2).toXMLString());
         * trace("intersection: " + CustomFuncs.XMLintersection(l1, l2).toXMLString());
         * trace("symm diff: " + CustomFuncs.XMLsymmetric_difference(l1, l2).toXMLString());
         * (Output:)
         * diff: <user name="bob"/>
         * <user name="susie"/>
         * union: <user name="bob"/>
         * <user grade="4" name="alice"/>
         * <user name="susie"/>
         * <user name="frank"/>
         * intersection: <user grade="4" name="alice"/>
         * symm diff: <user name="bob"/>
         * <user name="susie"/>
         * <user name="frank"/>
         */
        public static function XMLdifference(list1:XMLList, list2:XMLList) : XMLList {
            // list1 - list2 = set of nodes in list 1 minus any that also appear in list2
            var diff:XMLList = new XMLList();
            for each (var node:XML in list1) {
                if (!list2.contains(node)) {
                    diff += node;
                }
            }
            return diff;
        }
        
        public static function ArrDiff(arr1:Array, arr2:Array) : Array {
            var diff:Array = [];
            for each (var node:* in arr1) {
                if (arr2.indexOf(node) == -1) {
                    diff.push(node);
                }
            }
            return diff;
        }
        
        public static function XMLunion(list1:XMLList, list2:XMLList) : XMLList {
            // unique set of nodes in l1 or l2
            var union:XMLList = new XMLList(list1);
            for each (var node:XML in list2) {
                if (!list1.contains(node)) {
                    union += node;
                }
            }
            return union;
        }
        
        public static function ArrUnion(arr1:Array, arr2:Array) : Array {
            var union:Array = arr1.slice();
            for each (var node:* in arr2) {
                if (arr1.indexOf(node) == -1) {
                    union.push(node);
                }
            }
            return union;
        }
        
        public static function XMLintersection(list1:XMLList, list2:XMLList) : XMLList {
            // set of nodes in l1 and l2
            var intersection:XMLList = new XMLList();
            for each (var node:XML in list1) {
                if (list2.contains(node)) {
                    intersection += node;
                }
            }
            return intersection;
        }
        
        public static function XMLsymmetric_difference(list1:XMLList, list2:XMLList) : XMLList {
            // set of nodes in l1 or l2 but not both (xor)
            var symm_diff:XMLList = new XMLList();
            for each (var node:XML in list1) {
                if (!list2.contains(node)) {
                    symm_diff += node;
                }
            }
            for each (var node2:XML in list2) {
                if (!list1.contains(node2)) {
                    symm_diff += node2;
                }
            }
            return symm_diff;
        }
        
        
    }
    
}
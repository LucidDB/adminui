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
package com.flexsqladmin.sqladmin.utils
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    import mx.core.FlexGlobals;

    public final class CustomFuncs {
        
        public static function str2utf16le(str:String) : ByteArray {
            var utf16:ByteArray = new ByteArray();
            var i_char:uint;
            
            utf16.endian = Endian.LITTLE_ENDIAN;
            //utf16.writeByte(0xFF);
            //utf16.writeByte(0xFE);
            for (var i:uint = 0; i < str.length; i++) {
                i_char = str.charCodeAt(i);
                if (i_char < 0xff) {
                    // one byte char
                    utf16.writeByte(i_char);
                    utf16.writeByte(0);
                } else {
                    // two byte char
                    utf16.writeByte(i_char & 0x00ff);
                    utf16.writeByte(i_char >> 8);
                }
            }
            return utf16;
        }
        
        public static function random_string(
            len:Number = 8,
            alpha:String = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
        ) : String {
            var alpha_a:Array = alpha.split('');
            var rand:String = '';
            for (var i:Number = 0; i < len; i++) {
                rand += alpha_a[Math.floor(Math.random() * alpha_a.length)];
            }
            return rand;
        }
        
        // Blocks execution of a function until the given condition without blocking execution of the program.
        // (Experimental) This appears to fail when what is null.
        public static function when(what:*, comparison:String, with_what:*, do_what:Function) : void {
            if (comparison == '==' && what == with_what)
                do_what();
            else if (comparison == '!=' && what != with_what)
                do_what();
            else if (comparison == '<' && what < with_what)
                do_what();
            else if (comparison == '>' && what > with_what)
                do_what();
            else if (comparison == '&&' && (what && with_what))
                do_what();
            else if (comparison == '||' && (what || with_what))
                do_what();
            else
                FlexGlobals.topLevelApplication.callLater(when, [what, comparison, with_what, do_what]);
        }
        
        public static function XOR(a:*, b:*) : Boolean {
            return (a && !b) || (b && !a);
        }
        
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
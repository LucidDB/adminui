package com.flexsqladmin.sqladmin.utils
{
    public final class CustomFuncs {
        public static function wordMult(word:String, times:Number) : String {
            // 'hello' * 2 = 'hellohello'
            var new_word : String = new String(word);
            while (times > 0) {
                new_word += word;
                times -= 1;
            }
            return new_word;
        }
        
        // The following XML set functions are not implemented with efficiency in mind;
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
        
        public static function XMLunion(list1:XMLList, list2:XMLList) : XMLList {
            // set of nodes in l1 and l2
            var union:XMLList = new XMLList(list1);
            for each (var node:XML in list2) {
                if (!list1.contains(node)) {
                    union += node;
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
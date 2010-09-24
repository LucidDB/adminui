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
package com.flexsqladmin.sqladmin.model
{
    import com.adobe.cairngorm.model.ModelLocator;
    import com.flexsqladmin.sqladmin.components.ObjectTree;
    import com.flexsqladmin.sqladmin.vo.ConnectionVO;
    import com.flexsqladmin.sqladmin.vo.ExecutionTimer;
    import com.flexsqladmin.sqladmin.vo.QueryHistoryVO;
    
    import flash.utils.Dictionary;
    
    import flexlib.containers.SuperTabNavigator;
    
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;
    import mx.controls.DataGrid;
    
    [Bindable]
    public class ModelLocator implements com.adobe.cairngorm.model.ModelLocator
    {
    	private static var modelLocator:com.flexsqladmin.sqladmin.model.ModelLocator;
    	
    	public var querycount:int = 1;

        public var tabs : Dictionary = new Dictionary(); // contains arrays of component windows.
		public var main_tabnav : SuperTabNavigator;

        public var connectionVO:ConnectionVO;
    	public var tempConnectionVO:ConnectionVO;
    	public var connectionText:String = "";
    	public var metadata:XML;
        public var session_info:XMLList;
        public var users_list:Array;
        public var roles_list:Array;
        public var users_details:XMLList;
        public var roles_info:XML;
    	public var exectimer:ExecutionTimer;
    	public var catalogdata:XMLListCollection;
    	public var currentcatalogname:String = 'LOCALDB';
        
        public var object_tree:ObjectTree; // shut up compiler
    	
        public static function getInstance():com.flexsqladmin.sqladmin.model.ModelLocator
        {
            if (modelLocator == null)
                modelLocator = new com.flexsqladmin.sqladmin.model.ModelLocator(); 
            return modelLocator;
       	}
       
	   public function ModelLocator() 
	   {
	   		exectimer = new ExecutionTimer();
	   		connectionVO = new ConnectionVO();
	   		tempConnectionVO = new ConnectionVO();
            
	 	  	if ( com.flexsqladmin.sqladmin.model.ModelLocator.modelLocator != null )
	        	throw new Error( "Only one ModelLocator instance should be instantiated" );
	   }
    }
}


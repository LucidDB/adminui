/*
Copyright 2006-2010 Kevin Kazmierczak. All rights reserved.
Copyright 2010 Dynamo Business Intelligence Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY Dynamo Business Intelligence Corporation ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Dynamo Business Intelligence Corporation OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.flexsqladmin.sqladmin.model
{
    import com.adobe.cairngorm.model.ModelLocator;
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
    	public var aryQueryWindows:Dictionary = new Dictionary();
		public var query_results : Dictionary = new Dictionary(); // contains QueryResultInfo's.
        public var table_details : Dictionary = new Dictionary(); // contains TableDetailVO's
        public var users_windows : Dictionary = new Dictionary(); // contains UsersWindow's
        public var roles_windows : Dictionary = new Dictionary(); // contains RolesWindow's
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
            
            // Dictionaries don't support .length or .count, so we have to do it ourselves.
            aryQueryWindows._len = 0;
            query_results._len = 0;
            table_details._len = 0;
            users_windows._len = 0;
            roles_windows._len = 0;

	 	  	if ( com.flexsqladmin.sqladmin.model.ModelLocator.modelLocator != null )
	        	throw new Error( "Only one ModelLocator instance should be instantiated" );
	   }
    }
}


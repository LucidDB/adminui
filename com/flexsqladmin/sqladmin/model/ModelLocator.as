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


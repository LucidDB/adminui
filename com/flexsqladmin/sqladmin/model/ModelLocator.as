package com.flexsqladmin.sqladmin.model
{
    import com.adobe.cairngorm.model.ModelLocator;
    import com.flexsqladmin.sqladmin.vo.ConnectionVO;
    import com.flexsqladmin.sqladmin.vo.QueryHistoryVO;
    import mx.collections.XMLListCollection;
    import com.flexsqladmin.sqladmin.vo.ExecutionTimer;
    import com.flexsqladmin.sqladmin.components.ExecutionPlanWindow;
    import mx.controls.DataGrid;
    
    [Bindable]
    public class ModelLocator implements com.adobe.cairngorm.model.ModelLocator
    {
    	private static var modelLocator:com.flexsqladmin.sqladmin.model.ModelLocator;
    	
    	public var querycount:int = 1;
    	public var aryQueryWindows:Array = new Array();
    	public var connectionVO:ConnectionVO;
    	public var tempConnectionVO:ConnectionVO;
    	public var connectionText:String = "";
    	public var metadata:XML;
    	public var queryHistoryVO:QueryHistoryVO;
    	public var querydata:XMLListCollection;
    	public var querymessages:String;
    	public var exectimer:ExecutionTimer;
    	public var showplanwindow:ExecutionPlanWindow;
    	public var querydatagrid:DataGrid;
    	
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
	   		queryHistoryVO = new QueryHistoryVO();
	 	  	if ( com.flexsqladmin.sqladmin.model.ModelLocator.modelLocator != null )
	        	throw new Error( "Only one ModelLocator instance should be instantiated" );
	   }
    }
}


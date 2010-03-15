package com.flexsqladmin.sqladmin.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class ListCatalogsEvent extends CairngormEvent
	{
		
		public static var LISTCATALOGS:String = "listCatelogs";
		
		public function ListCatalogsEvent()
		{
			super(LISTCATALOGS);
		}
		
	}
}
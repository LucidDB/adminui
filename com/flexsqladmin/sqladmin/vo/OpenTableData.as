package com.flexsqladmin.sqladmin.vo
{
	public class OpenTableData
	{
		public var table:String = "";
		public var tablemetadata:Array;
		public var tablemetaxml:XML;
		
		public function OpenTableData(tab:String){
			tablemetadata = new Array();
			table = tab;
		}
		
		public function setTable(tab:String):void{
			table = tab;
		}
		
		public function getTable():String{
			return table;
		}
		
		public function setTableXML(tabxml:XML):void{
			tablemetaxml = tabxml;
		}
		
		public function getTableXML():XML{
			return tablemetaxml;
		}
		
		public function setMetaData(md:Array):void{
			tablemetadata = md;
		}	
		
		public function getMetaData():Array{
			return tablemetadata;
		}
	}
}
package com.flexsqladmin.sqladmin.components
{
	public class showPlanIcon
	{
		private var icon:String = "";
		private var icondir:String = "icons";
		
		public function showPlanIcon(i:String){
			icon = i;
		}
		
		public function getIcon():String{
			if(icon == "Clustered Index Scan")
				return icondir + "/Clustered Index Scan.png";
			else if(icon == "Clustered Index Seek")
				return icondir + "/Clustered Index Seek.png";
			else if(icon == "Nested Loops")
				return icondir + "/Nested Loops.gif";
			else if(icon == "Bookmark Lookup")
				return icondir + "/Bookmark Lookup.gif";
			else if(icon == "SELECT" || icon == "INSERT" || icon == "UPDATE" || icon == "DELETE")
				return icondir + "/Command.gif";
			else if(icon == "Compute Scalar")
				return icondir + "/Compute Scalar.gif";
			else if(icon == "Concatenation")
				return icondir + "/Concatenation.gif";
			else if(icon == "Sort")
				return icondir + "/Sort.gif";
			else if(icon == "Table Scan")
				return icondir + "/Table Scan.gif";
			else
				return icondir + "/Command.gif";
		}
	}
}
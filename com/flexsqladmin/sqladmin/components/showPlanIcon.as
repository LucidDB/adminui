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
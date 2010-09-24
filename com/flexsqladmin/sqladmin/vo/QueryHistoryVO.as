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
package com.flexsqladmin.sqladmin.vo
{
	import com.adobe.cairngorm.vo.ValueObject;
	import com.flexsqladmin.sqladmin.utils.CustomFuncs;
	
	import mx.formatters.DateFormatter;
	
	[Bindable]
	public class QueryHistoryVO implements ValueObject
	{
		public var history:String = "";
		public var dateformatter:DateFormatter = new DateFormatter();
		
		public function writeHistory(s:String, sqt:String):void{
			var pattern:RegExp = /[\r|\t]/gm;
			var timeStamp:Date = new Date();
			dateformatter.formatString = "LL:NN:SS A";
			if (sqt == "normal" || sqt == "spnormal" || sqt == "")
				sqt = "";
			else
				sqt = sqt.toUpperCase() + " - ";
			history = "<font color='#009900'><b>[" + dateformatter.format(timeStamp) + "]</b></font> : " + sqt + CustomFuncs.htmlEntities(s.replace(pattern, " ")) + "\n" + history;
		}
	}
}
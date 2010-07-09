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
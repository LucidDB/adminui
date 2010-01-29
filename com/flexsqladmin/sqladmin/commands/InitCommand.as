package com.flexsqladmin.sqladmin.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.business.Responder;
	import com.flexsqladmin.sqladmin.model.ModelLocator;
	import com.flexsqladmin.sqladmin.components.DebugWindow;

	public class InitCommand implements Command, Responder
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			DebugWindow.log("InitCommand:execute()"); 
		}
		
		public function onResult(event:*=null):void
		{
		}
		
		public function onFault(event:*=null):void
		{
		}
		
	}
}
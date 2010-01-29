package com.flexsqladmin.sqladmin.vo
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	[Bindable]
	public class ExecutionTimer
	{
		private var exectime:Timer;
		public var time:int;
		
		public function ExecutionTimer(){
			exectime = new Timer(1000);
            exectime.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		public function test():String{
			return "HELLO";
		}
		public function startTimer():void {
            exectime.start();
            time = 0;
        }
        
        public function stopTimer():void {
            exectime.stop();
        }
        
        private function timerHandler(event:TimerEvent):void {
            time += 1;
        }
	}
}
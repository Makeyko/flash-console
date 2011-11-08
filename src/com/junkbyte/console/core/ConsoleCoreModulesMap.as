package com.junkbyte.console.core
{
	import com.junkbyte.console.interfaces.IConsoleModule;
	import com.junkbyte.console.logging.ConsoleLogger;
	import com.junkbyte.console.logging.Logs;

	public class ConsoleCoreModulesMap
	{
		private static const NAME_TO_TYPE_MAP:Object = 
		{ 
			logger: ConsoleLogger, 
			logs: Logs
		}
		
		public static function isModuleWithNameValid(module:IConsoleModule, name:String):Boolean
		{
			var type:Class = NAME_TO_TYPE_MAP[name];
			return type == null || module is type;
		}
	}
}
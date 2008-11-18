﻿/*
* Copyright (c) 2008 Lu Aye Oo (Atticmedia)
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.

 * @class 		Console
 * @author 		Lu
 * @version 	Beta
 * 				
 * 
**/

/*

Project page: 

http://code.google.com/p/flash-console/

	USAGE:
		
		import com.atticmedia.console.*;
		c.start(this); // this = preferably the root
		
		// OR  c.start(this,"debug");
		// Start console, parameter "debug" (optional) sets the console's password.
		//  console will only open after you type "debug" in sequence at anytime on stage. 
		// Leave blank to disable password, where console will launch straight away.
		
		c.add("Hello World"); 
		// Output "Hello World" with default priority in currentChannel
		
		c.add( ["Hello World" , "this is", "an array", "of arguments"] );
		// Passes multiple arguments as array (for the time being this is the only alternative)
		
		c.add("Important Trace!", 10);
		// Output "Important Trace!" with priority 10 in currentChannel
		
		c.add("A Looping trace that I dont want to see a long list", 10, true);
		// Output the text in currentChannel, replacing the last 'repeating' line. preventing it from generating so many lines.
		// good for tracing loops.
		// use c.forceLine = # to force print the line on # frames. # = a number.
		
		c.ch("myChannel","Hello my Channel"); 
		// Output "Hello my Channel" in "myChannel" channel.
		// note: "global" channel show trace lines from all channels.
		
		c.ch("myChannel","Hello my Channel", 8); 
		// Output "Hello my Channel" in "myChannel" channel with priority 8
		// note: "global" channel show trace lines from all channels.
		
		c.ch("myChannel","Hello my Channel", 8, true); 
		// Output "Hello my Channel" in "myChannel" channel with priority 8 replacing the last 'repeating' line
		// note: "global" channel show trace lines from all channels.
		
		
		// OPTIONAL USAGE
		c.remove(); // Completely remove console
		c.clear(); // Clear tracing lines
		
		c.fpsMode = 1 // 0 = off. 1-5 various fps display formats
		c.fpsBase = 50  // (default: 100) set FPS's history length
		c.fps // (read) get current fps
		c.mspf // (read) get current ms per frame
		c.averageFPS // (read) get average fps
		c.averageMsPF // (read) get average ms per frame
		
		c.ui.preset = 2 // (default: 1) change layout format to preset number 
		c.paused = true // pauses printing in console, it still record and print back out on resume.
		c.enabled = false // disables printing and recording. pauses FPS/memory monitor.
		c.visible = false // (defauilt: true) set to change visibility. It will still record but will not update prints etc
		c.forceLine = 100; // (default:100)  frames before repeating line is forced to print to next line. set to -1 to never force. set to 0 to force every line.
		
		c.menuMode = 0 // (default:1) 0=channels+options 1=channels 2=options
		c.command = true; // (default: false) enable command line
		c.memoryMonitor = 1; // (default: 0) show memory usage in kb.
		c.width = 200; // (defauilt: 420) change width of console
		c.height = 200; //(defauilt: 16) change hight of console
		c.x = 300; // (defauilt: 0) change x of console
		c.y = 200; // (defauilt: 0) change y of console
		c.maxLines = 500; // maximum number of lines allowed to store. 0 = unlimited. setting to very high will slow down as it grows
		c.deleteLines = 200; // number of lines to delete when maximum line limit has reached
		c.tracing = true; // (default: false) when set, all console input will be re-traced during authoring
		c.alwaysOnTop = false; // (default: true) when set this console will try to keep it self on top of its parent display container.

		c.currentChannel = "myChannel"; // (default: "traces") change default channel to print.
		c.viewingChannel = "myChannel"; // (default: "global") change current channel view.
		
		
		//c.listenErrors(obj) // listen to obj for error events (does not work on all errors atm)
		c.remoting = true; // (default: false) set to broadcast traces
		c.isRemote = true; // (default: false) set to listen for broadcasts and traces in it self

*/
		
package com.atticmedia.console {
	import flash.events.EventDispatcher;	
	import flash.display.*;
	import flash.system.Capabilities;
	
	public class c{
		
		private static var _console:console;
		
		public static var allowInBrowser:Boolean = false;
		
		public function c() {
			throw new Error("[CONSOLE] Do not construct class. Please use c.start(mc:DisplayObjectContainer, password:String='')");
		}
		public static function start(mc:DisplayObjectContainer, pass:String = ""):void{
			// if running on browser , flash var 'allowConsole' needs to be set to true to allow starting
			// you can override this by setting c.allowInBrowser = true;
			if(!allowInBrowser && mc.stage && (Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX")){
				var flashVars:Object = mc.stage.loaderInfo.parameters;
				if(flashVars.allowConsole != "true"){
					return;
				}
			}
			if(_console){
				trace("[CONSOLE] already exists. Will keep using the previously created console. If you want to create a fresh 1, c.remove() first.");
			}else{
				_console = new com.atticmedia.console.console(pass);
				mc.addChild(_console);
			}
		}
		public static function get version():Number{
			return console.VERSION;
		}
		public static function ch(channel:Object, newLine:Object, priority:Number = 2, isRepeating:Boolean = false, skipSafe:Boolean = false):void{
			if(_console){
				_console.ch(channel,newLine,priority, isRepeating, skipSafe);
			}
		}
		public static function pk(channel:Object, newLine:Object, priority:Number = 2, isRepeating:Boolean = false, skipSafe:Boolean = false):void{
			if(_console){
				_console.pk(channel,newLine,priority, isRepeating, skipSafe);
			}
		}
		public static function listenErrors(obj:EventDispatcher):void{
			if(_console){
				_console.listenErrors(obj);
			}
		}
		public static function add(newLine:Object, priority:Number = 2, isRepeating:Boolean = false, skipSafe:Boolean = false):void{
			if(_console){
				_console.add(newLine,priority, isRepeating, skipSafe);
			}
		}
		public static function remove():void{
			if(_console){
				if(_console.parent){
					_console.parent.removeChild(_console);
				}
				_console.destroy();
				_console = null;
			}
		}
		public static function clear(channel:String = null):void{
			if(_console){
				_console.clear(channel);
			}
		}
		public static function fpsReset ():void{
			if(_console){
				_console.fps.reset();
			}
		}
		//
		//
		public static function startTimer(n:String):void{
			if(_console){
				_console.timers.start(n);
			}
		}
		public static function stopTimer(n:String):void{
			if(_console){
				_console.timers.stop(n);
			}
		}
		public static function nuldgeTimer(n:String):void{
			if(_console){
				_console.timers.nuldge(n);
			}
		}
		public static function get quietTimer ():Boolean{
			if(_console){
				return _console.timers.quiet;
			}
			return false;
		}
		public static function set quietTimer (v:Boolean):void{
			if(_console){
				_console.timers.quiet = v;
			}
		}
		//
		//
		public static function watch(o:Object,n:String = null):void{
			if(_console){
				_console.mm.watch(o,n);
			}
		}
		public static function unwatch(n:String):void{
			if(_console){
				_console.mm.unwatch(n);
			}
		}
		public static function gc():void {
			if(_console){
				_console.gc();
			}
		}
		//
		//
		//
		public static function get ui():userinterface{
			return getter("ui") as userinterface;
		}
		public static function get width():Number{
			return getter("Width") as Number;
		}
		public static function set width(v:Number):void{
			setter("Width",v);
		}
		public static function get height():Number{
			return getter("Height") as Number;
		}
		public static function set height(v:Number):void{
			setter("Height",v);
		}
		public static function get x():Number{
			return getter("x") as Number;
		}
		public static function set x(v:Number):void{
			setter("x",v);
		}
		public static function get y():Number{
			return getter("y") as Number;
		}
		public static function set y(v:Number):void{
			setter("y",v);
		}
		public static function get currentChannel():String{
			return getter("currentChannel") as String;
		}
		public static function set currentChannel(v:String):void{
			setter("currentChannel",v);
		}
		public static function get viewingChannel():String{
			return getter("viewingChannel") as String;
		}
		public static function set viewingChannel(v:String):void{
			setter("viewingChannel",v);
		}
		public static function get prefixChannelNames():String{
			return getter("prefixChannelNames") as String;
		}
		public static function set prefixChannelNames(v:String):void{
			setter("prefixChannelNames",v);
		}
		public static function get visible():Boolean{
			return getter("visible") as Boolean;
		}
		public static function set visible(v:Boolean):void{
			setter("visible",v);
		}
		public static function get paused():Boolean{
			return getter("paused") as Boolean;
		}
		public static function set paused(v:Boolean):void{
			setter("paused",v);
		}
		public static function get exists():Boolean{
			var e:Boolean = _console? true: false;
			return e;
		}
		public static function set enabled(v:Boolean):void{
			setter("enabled",v);
		}
		public static function get enabled():Boolean{
			return getter("enabled") as Boolean;
		}
		public static function set tracing(v:Boolean):void{
			setter("tracing",v);
		}
		public static function get tracing():Boolean{
			return getter("tracing") as Boolean;
		}
		public static function set tracingChannel(v:String):void{
			setter("tracingChannel",v);
		}
		public static function get tracingChannel():String{
			return getter("tracingChannel") as String;
		}
		public static function set alwaysOnTop(v:Boolean):void{
			setter("alwaysOnTop",v);
		}
		public static function get alwaysOnTop():Boolean{
			return getter("alwaysOnTop") as Boolean;
		}
		public static function get memoryMonitor():int{
			return getter("memoryMonitor") as int;
		}
		public static function set memoryMonitor(v:int):void{
			setter("memoryMonitor",v);
		}
		public static function get maxLines():int{
			return getter("maxLines") as int;
		}
		public static function set maxLines(v:int):void{
			setter("maxLines",v);
		}
		public static function get deleteLines():int{
			return getter("deleteLines") as int;
		}
		public static function set deleteLines(v:int):void{
			setter("deleteLines",v);
		}
		public static function set command (v:Boolean):void{
			setter("command",v);
		}
		public static function get command ():Boolean{
			return getter("command") as Boolean;
		}
		public static function get remoting():Boolean{
			return getter("remoting") as Boolean;
		}
		public static function set remoting(v:Boolean):void{
			setter("remoting",v);
		}
		public static function get isRemote():Boolean{
			return getter("isRemote") as Boolean;
		}
		public static function set isRemote(v:Boolean):void{
			setter("isRemote",v);
		}
		public static function get forceLine():Number{
			return getter("forceLine") as Number;
		}
		public static function set forceLine(v:Number):void{
			setter("forceLine",v);
		}
		public static function get menuMode():int{
			return getter("menuMode") as int;
		}
		public static function set menuMode(v:int):void{
			setter("menuMode",v);
		}
		//
		public static function get fpsMode ():int{
			if(_console){
				return _console.fps.running?_console.fps.format:0;
			}
			return 0;
		}
		public static function set fpsMode (v:int):void{
			if(v == 0 && _console.fps.running){
				_console.fps.pause();
			}else if(!_console.fps.running && v>0){
				_console.fps.start();
			}
			if(v>0){
				_console.fps.format = v;
			}
		}
		//
		public static function get fpsBase():int{
			if(_console){
				return _console.fps.base;
			}
			return 0;
		}
		public static function set fpsBase(v:int):void{
			if(_console){
				_console.fps.base = v;
			}
		}
		public static function get fps ():Number{
			if(_console){
				return _console.fps.current;
			}
			return 0;
		}
		public static function get averageFPS ():Number{
			if(_console){
				return _console.fps.averageFPS;
			}
			return 0;
		}
		public static function get mspf ():Number{
			if(_console){
				return _console.fps.mspf;
			}
			return 0;
		}
		public static function get averageMsPF ():Number{
			if(_console){
				return _console.fps.averageMsPF;
			}
			return 0;
		}
		//
		//
		//
		public static function get minMemory():uint {
			if(_console){
				return _console.mm.minMemory;
			}
			return 0;
		}
		public static function get maxMemory():uint {
			if(_console){
				return _console.mm.maxMemory;
			}
			return 0;
		}
		public static function get currentMemory():uint {
			if(_console){
				return _console.mm.currentMemory;
			}
			return 0;
		}
		//
		//
		//
		
		public static function inspect(obj:Object, detail:Boolean = true):void {
			if(_console && _console.cl){
				add("INSPECT: "+ _console.cl.inspect(obj,detail));
			}
		}
		public static function get base():Object{
			if(_console && _console.cl){
				return _console.cl.base;
			}
			return null;
		}
		public static function set base(v:Object):void{
			if(_console && _console.cl){
				_console.cl.base = v;
			}
		}
		public static function store(n:String, obj:Object):void{
			if(_console  && _console.cl){
				_console.cl.store(n, obj);
			}
		}
		public static function run(o:String):void{
			if(_console && _console.cl){
				_console.cl.run(o);
			}
		}
		public static function bindKey(char:String, ctrl:Boolean, alt:Boolean, shift:Boolean, fun:Function ,...args:Array):void{
			if(_console){
				_console.bindKey(char, ctrl, alt, shift, fun ,args);
			}
		}
		// UI
		// set ur own custom priority colour. pass in this format: "FFAA00"
		public static function setPriorityColour(p:int, col:String):void{
			if(_console  && _console.ui){
				_console.ui.setPriorityHex(p, col);
			}
		}
		//
		//
		//
		//
		//
		private static function getter(str:String):Object{
			if(_console){
				return _console[str];
			}else{
				return null;
			}
		}
		private static function setter(str:String,v:Object):void{
			if(_console){
				_console[str] = v;
			}
		}
		//
		//	This is for debugging of console.
		//	DO NOT USE THIS!
		public static function get me():console{
			return _console;
		}
	}
}
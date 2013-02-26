package ufront.web.module;

import ufront.web.HttpApplication;
import haxe.PosInfos;

class TraceToFileModule implements ITraceModule
{
	var file : haxe.io.Output;
	var path : String;
	static var REMOVENL = ~/[\n\r]/g;
	public function new(path : String)
	{
		this.path = path;
	}
	public function init(application : HttpApplication)
	{

	}
	public function trace(msg : Dynamic, ?pos : PosInfos) : Void
	{
		getFile().writeString(format(msg, pos) + "\n");
	}

	static function format(msg : Dynamic, pos : PosInfos)
	{
/*
	var fileName : String;
	var lineNumber : Int;
	var className : String;
	var methodName : String;
	var customParams : Array<Dynamic>;
*/
		msg = REMOVENL.replace(msg, '\\n');
		return '${Date.now()}: ${pos.className}.${pos.methodName}(${pos.lineNumber}) ${Dynamics.string(msg)}';
	}

	public function dispose()
	{
		path = null; // prevents reusing the instance
		if(null == file)
			return;
		file.close();
		file = null;
	}

	function getFile()
	{
		if(null == file)
			file = thx.sys.io.File.append(path);
		return file;
	}
}
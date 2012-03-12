package ufront.web.module;

import ufront.web.HttpApplication;
import haxe.PosInfos;

class TraceToBrowserModule implements ITraceModule
{
	var messages : Array<{ msg : Dynamic, pos : PosInfos }>;
	public function new()
	{
		messages = [];
	}
	public function init(application : HttpApplication)
	{
		application.onLogRequest.add(_sendContent);
	}
	public function trace(msg : Dynamic, ?pos : PosInfos) : Void
	{
		messages.push({ msg : msg, pos : pos });
	}
	public function dispose()
	{

	}
	function _sendContent(application : HttpApplication)
	{
		if(application.response.contentType != "text/html")
		{
			messages = [];
			return;
		}
		var results = [];
		for(msg in messages)
		{
			results.push(_formatMessage(msg));
		}
		if(results.length > 0)
		{
			application.response.write(
				'\n<script type="text/javascript">\n' +
				results.join('\n') +
				'\n</script>'
			);
		}
		messages = [];
	}

	function _formatMessage(m : { msg : Dynamic, pos : PosInfos }) : String
	{
		var type = if(m.pos != null && m.pos.customParams != null ) m.pos.customParams[0] else null;
		if( type != "warn" && type != "info" && type != "debug" && type != "error" )
			type = if( m.pos == null ) "error" else "log";
	   	var msg = (m.pos.className.split('.').pop()) + "." + m.pos.methodName + "(" + m.pos.lineNumber + "): " + Std.string(m.msg);
		return 'console.'+type+'(decodeURIComponent("'+StringTools.urlEncode(msg)+'"))';
	}
}
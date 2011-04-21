package ufront.web.module;            
import haxe.PosInfos;
import ufront.web.routing.EmptyRoute;
import ufront.web.routing.RequestContext;
import ufront.web.routing.RouteData;
import ufront.web.mvc.MvcRouteHandler;
import ufront.web.mvc.Controller;
import ufront.web.HttpApplication;
import ufront.web.IHttpModule;   
using Hashes;    
using Strings;         
using Types;

class TraceModule implements IHttpModule 
{     
	var messages : Array<{ msg : Dynamic, pos : PosInfos }>;
	var _old : Dynamic;
	public function new()
	{
		_old = haxe.Log.trace;
		haxe.Log.trace = this.trace;
		messages = [];
	}
	public function init(application : HttpApplication)
	{
		application.onLogRequest.add(_sendContent);
	}
	
	function _sendContent(application : HttpApplication)
	{       
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
	
	public function dispose()
	{
		haxe.Log.trace = _old;
	}
	
	public function trace( v : Dynamic, ?pos : PosInfos ) : Void
	{   
		messages.push({ msg : v, pos : pos });
	}
}
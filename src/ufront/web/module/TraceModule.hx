package ufront.web.module;            
import haxe.PosInfos;
import ufront.web.routing.EmptyRoute;
import ufront.web.routing.RequestContext;
import ufront.web.routing.RouteData;
import ufront.web.mvc.MvcRouteHandler;
import ufront.web.mvc.Controller;
import ufront.web.HttpApplication;
import ufront.web.IHttpModule;   
using thx.collections.UHash;    
using thx.text.UString;         
using thx.type.UType;

class TraceModule implements IHttpModule 
{     
	var messages : Array<{ msg : Dynamic, pos : PosInfos }>;
	var _old : Dynamic;
	public function new()
	{
		messages = [];
	}
	public function init(application : HttpApplication)
	{  
		_old = haxe.Log.trace;
		haxe.Log.trace = trace;
		application.endRequest.add(_sendContent);
	}
	
	function _sendContent(application : HttpApplication)
	{      
		for(msg in messages)
			application.response.write(_printMessage(msg)); 
		haxe.Log.trace = _old;
	}     
	
	function _printMessage(m : { msg : Dynamic, pos : PosInfos }) : String
	{
		var type = if(m.pos != null && m.pos.customParams != null ) m.pos.customParams[0] else null;
		if( type != "warn" && type != "info" && type != "debug" && type != "error" )
			type = if( m.pos == null ) "error" else "log";
		return '<script type="text/javascript">console.'+type+'(decodeURIComponent("'+StringTools.urlEncode(m.msg)+'"))</script>';
	}
	
	public function dispose()
	{
		
	}
	
	public function trace( v : Dynamic, ?pos : PosInfos ) : Void
	{
		messages.push({ msg : v, pos : pos });
	}
}
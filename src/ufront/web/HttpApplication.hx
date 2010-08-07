/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;

import haxe.io.BytesOutput;
import hxevents.Dispatcher;
import hxevents.EventException;
import udo.neutral.Lib;
import udo.error.NullArgument;

class HttpApplication
{
	public var context(default, null) : HttpContext;
	public var request(getRequest, null) : HttpRequest;
	public var response(getResponse, null) : HttpResponse;
	public var session(getSession, null) : IHttpSessionState;
	public var modules(default, null) : List<IHttpModule>;
	
	public var onBegin(default, null) : Dispatcher<HttpApplication>;
	public var onEnd(default, null) : Dispatcher<HttpApplication>;
	public var onResolveCache(default, null) : Dispatcher<HttpApplication>;
	public var onAfterResolveCache(default, null) : Dispatcher<HttpApplication>;
	public var onUpdateCache(default, null) : Dispatcher<HttpApplication>;
	public var onAfterUpdateCache(default, null) : Dispatcher<HttpApplication>;
	public var onHandler(default, null) : Dispatcher<HttpApplication>;
	public var onAfterHandler(default, null) : Dispatcher<HttpApplication>;
	public var onLog(default, null) : Dispatcher<HttpApplication>;
	public var onAfterLog(default, null) : Dispatcher<HttpApplication>;
	
	var _completed : Bool;
	var _dispatching : Bool;
	
	public function new(context : HttpContext)
	{
		NullArgument.throwIfNull(context, "context");
		this.context = context;
		onBegin = new Dispatcher();
		onEnd = new Dispatcher();
		
		onResolveCache = new Dispatcher();
		onAfterResolveCache = new Dispatcher();
		onHandler = new Dispatcher();
		onAfterHandler = new Dispatcher();
		onUpdateCache = new Dispatcher();
		onAfterUpdateCache = new Dispatcher();
		onLog = new Dispatcher();
		onAfterLog = new Dispatcher();
		
		modules = new List();
		_completed = false;
		_dispatching = false;
	}
	
	public function init()
	{
		// wire modules
		for (module in modules)
			module.init(this);
		
		_dispatch(onBegin);
		_dispatch(onResolveCache);
		_dispatch(onAfterResolveCache);
		_dispatch(onHandler);
		_dispatch(onAfterHandler);
		_dispatch(onUpdateCache);
		_dispatch(onAfterUpdateCache);
		_dispatch(onLog);
		_dispatch(onAfterLog);
		
		// flush contents
		response.flush();
		
		// this event is always dispatched no matter what
		onEnd.dispatch(this);
	}
	
	function _dispatch(dispatcher : Dispatcher<HttpApplication>)
	{
		if (_completed)
			return;
		_dispatching = true;
		dispatcher.dispatch(this);
		_dispatching = false;
	}
	
	public function dispose()
	{
		for (module in modules)
			module.dispose();
		context.dispose();
	}
	
	public function completeRequest()
	{
		_completed = true;
		if(_dispatching)
			throw StopPropagation;
	}

	function getRequest() return context.request
	function getResponse() return context.response
	function getSession() return context.session
}
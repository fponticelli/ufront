/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;
import ufront.web.IHttpModule;
import uform.util.Error;
import ufront.web.routing.RoutesCollection;

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
	
	public var onError(default, null) : Dispatcher<{ application : HttpApplication, error : Error}>;
	
	
	public var routes(default, null) : RoutesCollection;
	
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
		onError = new Dispatcher();
		
		modules = new List();
		_completed = false;
		_dispatching = false;
		routes = new RoutesCollection();
		
	}
	
	public function init()
	{
		// wire modules
		for (module in modules)
			_initModule(module);
		
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
		_flush();
		
		// this event is always dispatched no matter what
		_dispatchEnd();
	}
	
	function _flush()
	{
		try 
		{
			response.flush();
		} catch(e : Dynamic) {
			_dispatchError(e);
		}
	}
		
	function _initModule(module : IHttpModule)
	{
		try 
		{
			module.init(this);
		} catch(e : Dynamic) {
			_dispatchError(e);
		}
	}
	
	function _dispatchEnd()
	{
		try 
		{
			onEnd.dispatch(this);
		} catch(e : Dynamic) {
			_dispatchError(e);
		}
	}
	
	function _dispatch(dispatcher : Dispatcher<HttpApplication>)
	{
		if (_completed)
			return;
		_dispatching = true;
		try 
		{
			dispatcher.dispatch(this);
		} catch(e : Dynamic) {
			_dispatchError(e);
		}
		_dispatching = false;
	}
	
	function _dispatchError(e : Dynamic) 
	{
		var event = { 
			application : this,
			error : Std.is(e, Error) ? e : new Error(Std.string(e))
		};
		onError.dispatch(event);
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
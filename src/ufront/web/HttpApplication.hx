/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;

import ufront.web.IHttpModule;
import thx.error.Error;
import hxevents.AsyncDispatcher;
import hxevents.Dispatcher;

class HttpApplication
{
	public var httpContext(default, null) : HttpContext;
	public var request(get, null) : HttpRequest;
	public var response(get, null) : HttpResponse;
	public var session(get, null) : IHttpSessionState;
	public var modules(default, null) : List<IHttpModule>;

	var _handler : IHttpHandler;
	var _completed : Bool;

	///// Events /////

	/**
	 * The onBeginRequest event signals the creation of any given new request.
	 * This event is always raised and is always the first event to occur during the processing of a request.
	 */
	public var onBeginRequest(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * The onAuthenticateRequest event signals that the configured authentication mechanism has authenticated
	 * the current request. Subscribing to the AuthenticateRequest event ensures that the request will be
	 * authenticated before processing the attached module or event handler.
	 */
	//public var onAuthenticateRequest(default, null) : Dispatcher<HttpApplication>;

	/**
	 * The onPostAuthenticateRequest event is raised after the AuthenticateRequest event has occurred.
	 * Functionality that subscribes to the PostAuthenticateRequest event can access any data that is
	 * processed by the PostAuthenticateRequest.
	 */
	//public var onPostAuthenticateRequest(default, null) : Dispatcher<HttpApplication>;

	/**
	 * Occurs when a security module has verified user authorization
	 */
	//public var onAuthorizeRequest(default, null) : Dispatcher<HttpApplication>;

	/**
	 * Occurs when the user for the current request has been authorized.
	 */
	//public var onPostAuthorizeRequest(default, null) : Dispatcher<HttpApplication>;

	/**
	 * Occurs to let the caching modules serve requests from the cache, bypassing execution of the event
	 * handler (for example, a page or an XML Web service).
	 */
	public var onResolveRequestCache(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when execution of the current event handler is bypassed and allows a caching module to
	 * serve a request from the cache.
	 */
	public var onPostResolveRequestCache(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when a request handler is selected to respond to the request.
	 */
	public var onMapRequestHandler(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when the current request is mapped to the appropriate event handler.
	 */
	public var onPostMapRequestHandler(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when the current state (for example, session state) that is associated with the current
	 * request is acquired.
	 */
	public var onAcquireRequestState(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when the request state (for example, session state) that is associated with the current
	 * request has been obtained.
	 */
	public var onPostAcquireRequestState(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs just before executing an event handler (for example, a page or an XML Web service).
	 */
	public var onPreRequestHandlerExecute(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when the event handler (for example, a page or an XML Web service) finishes execution.
	 */
	public var onPostRequestHandlerExecute(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs after ASP.NET finishes executing all request event handlers. This event causes state
	 * modules to save the current state data.
	 */
	public var onReleaseRequestState(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when all request event handlers have completed executing and the request state data has been stored.
	 */
	public var onPostReleaseRequestState(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when an event handler finishes execution in order to let caching modules store responses that will
	 * be used to serve subsequent requests from the cache.
	 */
	public var onUpdateRequestCache(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when caching modules are finished updating and storing responses that are used to serve subsequent
	 * requests from the cache.
	 */
	public var onPostUpdateRequestCache(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs just before any logging is performed for the current request.
	 */
	public var onLogRequest(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when all the event handlers for the LogRequest event has completed processing.
	 */
	public var onPostLogRequest(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs as the last event in the HTTP pipeline chain of execution when responding to a request.
	 */
	public var onEndRequest(default, null) : Dispatcher<HttpApplication>;

	/**
	 * Occurs when an unhandled exception is thrown.
	 */
	public var onApplicationError(default, null) : AsyncDispatcher<{ application : HttpApplication, error : Error}>;

	///// End Events /////

	public function new(?httpContext : HttpContext)
	{
		this.httpContext = (httpContext == null) ? HttpContext.createWebContext() : httpContext;

		onBeginRequest = new AsyncDispatcher();

		onResolveRequestCache = new AsyncDispatcher();
		onPostResolveRequestCache = new AsyncDispatcher();

		onMapRequestHandler = new AsyncDispatcher();
		onPostMapRequestHandler = new AsyncDispatcher();

		onAcquireRequestState = new AsyncDispatcher();
		onPostAcquireRequestState = new AsyncDispatcher();

		onPreRequestHandlerExecute = new AsyncDispatcher();
		onPostRequestHandlerExecute = new AsyncDispatcher();

		onReleaseRequestState = new AsyncDispatcher();
		onPostReleaseRequestState = new AsyncDispatcher();

		onUpdateRequestCache = new AsyncDispatcher();
		onPostUpdateRequestCache = new AsyncDispatcher();

		onLogRequest = new AsyncDispatcher();
		onLogRequest.add(_executingLogRequest);
		onPostLogRequest = new AsyncDispatcher();

		onEndRequest = new Dispatcher();

		onApplicationError = new AsyncDispatcher();

		modules = new List();

		_completed = false;
	}

	var _logDispatched : Bool;
	var _flushed : Bool;

	function _executingLogRequest(_)
	{
		_logDispatched = true;
	}

	public function execute()
	{
		_flushed = _logDispatched = false;
		// wire modules
		for (module in modules)
			_initModule(module);

		_dispatchChain([
			onBeginRequest,
			onResolveRequestCache,
			onPostResolveRequestCache,
			onMapRequestHandler,
			onPostMapRequestHandler,
			onAcquireRequestState,
			onPostAcquireRequestState,
			onPreRequestHandlerExecute,
			onPostRequestHandlerExecute,
			onReleaseRequestState,
			onPostReleaseRequestState,
			onUpdateRequestCache,
			onPostUpdateRequestCache,
			onLogRequest,
			onPostLogRequest
		], _conclude);
	}

	function _conclude()
	{
		// flush contents
		_flush();
		// this event is always dispatched no matter what
		_dispatchEnd();
		_dispose();
	}

	function _flush()
	{
		try
		{
			if(!_flushed)
			{
				_flushed = true;
				response.flush();
			}
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
			onEndRequest.dispatch(this);
		} catch (e : Dynamic) {
			_dispatchError(e);
		}
	}

	function _dispatchChain(dispatchers : Array<AsyncDispatcher<HttpApplication>>, afterEffect : Void -> Void)
	{
#if php
// PHP has issues with long chains of methods
        for(dispatcher in dispatchers)
		{
	    	if(_completed)
				break;
			dispatcher.dispatch(this, null, _dispatchError);
		}
		if(null != afterEffect)
			afterEffect();
#else
		var self = this;
		var next = null;
		next = function()
		{
			var dispatcher = dispatchers.shift();
			if(self._completed || null == dispatcher)
			{
				if(null != afterEffect)
					afterEffect();
				return;
			}
			dispatcher.dispatch(self, next, self._dispatchError);
		}
		next();
#end
	}

	function _dispatchError(e : Dynamic)
	{
		if(!_logDispatched)
		{
			_dispatchChain([onLogRequest, onPostLogRequest], _dispatchError.bind(e));
			return;
		}
		var event = {
			application : this,
			error : Std.is(e, Error) ? e : new Error(Std.string(e))
		};
		if(!onApplicationError.has())
		{
			throw event.error;
		}
		else
		{
			onApplicationError.dispatch(event);
		}
		_conclude();
	}


	function _dispose()
	{
		for (module in modules)
			module.dispose();
		httpContext.dispose();
	}

	public function completeRequest()
	{
		_completed = true;
	}

	function get_request() return httpContext.request;
	function get_response() return httpContext.response;
	function get_session() return httpContext.session;
}
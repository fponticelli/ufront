/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;

import haxe.PosInfos;
import ufront.web.IHttpModule;
import ufront.web.error.PageNotFoundError;
import ufront.web.routing.RequestContext;
import ufront.web.routing.RouteCollection;
import ufront.web.routing.UrlRoutingModule;

import thx.error.Error;

import hxevents.AsyncDispatcher; 
import hxevents.Dispatcher; 

class HttpApplication
{   
	public var httpContext(default, null) : HttpContext;
	public var request(getRequest, null) : HttpRequest;
	public var response(getResponse, null) : HttpResponse;
	public var session(getSession, null) : IHttpSessionState;
	public var modules(default, null) : List<IHttpModule>;
	
	var _handler : IHttpHandler;	
	var _completed : Bool;

	///// Events /////
	
	/**
	 * The BeginRequest event signals the creation of any given new request. 
	 * This event is always raised and is always the first event to occur during the processing of a request.
	 */
	public var beginRequest(default, null) : AsyncDispatcher<HttpApplication>;
	
	/**
	 * The AuthenticateRequest event signals that the configured authentication mechanism has authenticated 
	 * the current request. Subscribing to the AuthenticateRequest event ensures that the request will be 
	 * authenticated before processing the attached module or event handler.
	 */
	//public var authenticateRequest(default, null) : Dispatcher<HttpApplication>;
	
	/**
	 * The PostAuthenticateRequest event is raised after the AuthenticateRequest event has occurred. 
	 * Functionality that subscribes to the PostAuthenticateRequest event can access any data that is 
	 * processed by the PostAuthenticateRequest.
	 */
	//public var postAuthenticateRequest(default, null) : Dispatcher<HttpApplication>;

	/**
	 * Occurs when a security module has verified user authorization
	 */
	//public var authorizeRequest(default, null) : Dispatcher<HttpApplication>;
	
	/**
	 * Occurs when the user for the current request has been authorized.
	 */
	//public var postAuthorizeRequest(default, null) : Dispatcher<HttpApplication>;
	
	/**
	 * Occurs to let the caching modules serve requests from the cache, bypassing execution of the event 
	 * handler (for example, a page or an XML Web service).
	 */
	public var resolveRequestCache(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when execution of the current event handler is bypassed and allows a caching module to 
	 * serve a request from the cache.
	 */
	public var postResolveRequestCache(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when a request handler is selected to respond to the request.
	 */
	public var mapRequestHandler(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when the current request is mapped to the appropriate event handler.
	 */
	public var postMapRequestHandler(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when the current state (for example, session state) that is associated with the current 
	 * request is acquired.
	 */
	public var acquireRequestState(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when the request state (for example, session state) that is associated with the current 
	 * request has been obtained.
	 */
	public var postAcquireRequestState(default, null) : AsyncDispatcher<HttpApplication>;
	
	/**
	 * Occurs just before executing an event handler (for example, a page or an XML Web service).
	 */
	public var preRequestHandlerExecute(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when the event handler (for example, a page or an XML Web service) finishes execution.
	 */
	public var postRequestHandlerExecute(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs after ASP.NET finishes executing all request event handlers. This event causes state 
	 * modules to save the current state data.
	 */
	public var releaseRequestState(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when all request event handlers have completed executing and the request state data has been stored.
	 */
	public var postReleaseRequestState(default, null) : AsyncDispatcher<HttpApplication>;
	
	/**
	 * Occurs when an event handler finishes execution in order to let caching modules store responses that will 
	 * be used to serve subsequent requests from the cache.
	 */
	public var updateRequestCache(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when caching modules are finished updating and storing responses that are used to serve subsequent 
	 * requests from the cache.
	 */
	public var postUpdateRequestCache(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs just before any logging is performed for the current request.
	 */
	public var logRequest(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs when all the event handlers for the LogRequest event has completed processing.
	 */
	public var postLogRequest(default, null) : AsyncDispatcher<HttpApplication>;

	/**
	 * Occurs as the last event in the HTTP pipeline chain of execution when responding to a request.
	 */
	public var endRequest(default, null) : Dispatcher<HttpApplication>;
	
	/**
	 * Occurs when an unhandled exception is thrown.
	 */
	public var applicationError(default, null) : AsyncDispatcher<{ application : HttpApplication, error : Error}>;
	
	///// End Events /////
		
	public function new(?httpContext : HttpContext)
	{                    
		this.httpContext = (httpContext == null) ? HttpContext.createWebContext() : httpContext;
		
		beginRequest = new AsyncDispatcher();
		
		resolveRequestCache = new AsyncDispatcher();		
		postResolveRequestCache = new AsyncDispatcher();

		mapRequestHandler = new AsyncDispatcher();
		postMapRequestHandler = new AsyncDispatcher();
		
		acquireRequestState = new AsyncDispatcher();
		postAcquireRequestState = new AsyncDispatcher();
		
		preRequestHandlerExecute = new AsyncDispatcher();
		postRequestHandlerExecute = new AsyncDispatcher();
		
		releaseRequestState = new AsyncDispatcher();
		postReleaseRequestState = new AsyncDispatcher();
		
		updateRequestCache = new AsyncDispatcher();
		postUpdateRequestCache = new AsyncDispatcher();
		
		logRequest = new AsyncDispatcher();
		postLogRequest = new AsyncDispatcher();
		
		endRequest = new Dispatcher();
		
		applicationError = new AsyncDispatcher();
		
		modules = new List();
	
		_completed = false; 	
	}
	
	public function init()
	{		
		// wire modules
		for (module in modules)
			_initModule(module);
		
		_dispatchChain([
			beginRequest, 
			resolveRequestCache,
			postResolveRequestCache,
			mapRequestHandler,
			postMapRequestHandler,
			acquireRequestState,
			postAcquireRequestState,
			preRequestHandlerExecute,
			postRequestHandlerExecute,
			releaseRequestState,
			postReleaseRequestState,
			updateRequestCache,
			postUpdateRequestCache,
			logRequest,
			postLogRequest
		]);

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
			endRequest.dispatch(this);
		} catch (e : Dynamic) {
			_dispatchError(e);
		}
	}
	
	function _dispatchChain(dispatchers : Array<AsyncDispatcher<HttpApplication>>)
	{                    
		var self = this;
		var next = null;
		next = function()
		{
			var dispatcher = dispatchers.shift();
			if(self._completed || null == dispatcher)
				return;
			dispatcher.dispatch(self, next, self._dispatchError);
		}
		next();
	}
	
	function _dispatchError(e : Dynamic) 
	{
		var event = { 
			application : this,
			error : Std.is(e, Error) ? e : new Error(Std.string(e))
		}; 
		
		if(!applicationError.has())
		{  
			throw event.error;
		}
		else
		{                             
			applicationError.dispatch(event);
		}
	}
	
	
	public function dispose()
	{
		for (module in modules)
			module.dispose();
		httpContext.dispose();
	}
	
	public function completeRequest()
	{
		_completed = true;
	}

	function getRequest() return httpContext.request
	function getResponse() return httpContext.response
	function getSession() return httpContext.session
}
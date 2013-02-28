package ufront.web.mvc;
import ufront.web.mvc.IViewEngine;
import ufront.web.mvc.ControllerContext;
import ufront.web.mvc.IView;
import ufront.web.IHttpSessionState;
import ufront.web.HttpResponse;
import ufront.web.HttpRequest;
import ufront.web.routing.RouteData;
import ufront.web.routing.RequestContext;
import ufront.web.HttpContext;
import ufront.web.mvc.Controller;
import haxe.ds.StringMap;

/** Encapsulates information that is related to rendering a view. */
class ViewContext
{
	/** Gets the controller. */
	public var controller(default, null) : ControllerBase;
	
	/** Gets the controller context. */
	public var controllerContext(default, null) : ControllerContext;

	/** Gets the HTTP context. */
	public var httpContext(default, null) : HttpContext;
	
	/** Gets the request context. */
	public var requestContext(default, null) : RequestContext;
	
	/** Gets the route data associated with the request. */
	public var routeData(default, null) : RouteData;
	
	/** Gets the current view. */
	public var view(default, null) : IView;

	/** Gets the data associated with the view. */
	public var viewData(default, null) : StringMap<Dynamic>;

	/** Gets the original HTTP request. */
	public var request(default, null) : HttpRequest;

	/** Gets the HTTP response. */
	public var response(default, null) : HttpResponse;

	/** Gets the session state info associated with the request. */
	public var session(default, null) : IHttpSessionState;

	/** Gets the view engine currently being used. */
	public var viewEngine(default, null) : IViewEngine;

	/** Gets the array of view helpers that are available to the view. */
	public var viewHelpers(default, null) : Array<IViewHelper>;

	public function new(controllerContext:ControllerContext, view:IView, viewEngine : IViewEngine, viewData:StringMap<Dynamic>, viewHelpers : Array<IViewHelper>)
	{
		this.controllerContext = controllerContext;
		this.controller = controllerContext.controller;
		this.requestContext = controllerContext.requestContext;
		this.httpContext = requestContext.httpContext;
		this.routeData = requestContext.routeData;
		this.view = view;
		this.viewData = viewData;
		this.viewEngine = viewEngine;
		this.request = httpContext.request;
		this.response = httpContext.response;
		this.session = httpContext.session;
		this.viewHelpers = viewHelpers;
	}
}
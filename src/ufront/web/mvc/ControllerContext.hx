package ufront.web.mvc;
import ufront.web.IHttpSessionState;
import ufront.web.HttpResponse;
import ufront.web.HttpRequest;
import ufront.web.routing.RouteData;
import ufront.web.HttpContext;
import ufront.web.mvc.Controller;
import ufront.web.routing.RequestContext;

/** Encapsulates information about an HTTP request that matches specified RouteBase and ControllerBase instances. */
class ControllerContext
{
	/** Gets or sets the controller. */
	public var controller : ControllerBase;

	/** Gets or sets the request context. */
	public var requestContext : RequestContext;

	/** Gets or sets the HTTP context. */
	public var httpContext : HttpContext;

	/** Gets or sets the URL route data. */
	public var routeData : RouteData;
	
	public var request : HttpRequest;
	public var response : HttpResponse;
	public var session : IHttpSessionState;

	public function new(controller : ControllerBase, requestContext : RequestContext)
	{
		this.controller = controller;
		this.requestContext = requestContext;
		this.httpContext = requestContext.httpContext;
		this.routeData = requestContext.routeData;

		this.request = httpContext.request;
		this.response = httpContext.response;
		this.session = httpContext.session;
	}
}
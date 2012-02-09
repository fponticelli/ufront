package ufront.web.mvc;
import ufront.web.IHttpSessionState;
import ufront.web.HttpResponse;
import ufront.web.HttpRequest;
import ufront.web.routing.RouteData;
import ufront.web.HttpContext;
import ufront.web.mvc.Controller;
import ufront.web.routing.RequestContext;

class ControllerContext
{
	public var controller : ControllerBase;
	public var requestContext : RequestContext;
	public var httpContext : HttpContext;
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
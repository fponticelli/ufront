package ufront.web.mvc;
import ufront.web.mvc.ControllerContext;
import ufront.web.mvc.IView;             
import ufront.web.IHttpSessionState;
import ufront.web.HttpResponse;
import ufront.web.HttpRequest;
import ufront.web.routing.RouteData;
import ufront.web.routing.RequestContext;
import ufront.web.HttpContext;
import ufront.web.mvc.Controller;

class ViewContext 
{    
	public var controller(default, null) : Controller;
	public var httpContext(default, null) : HttpContext;
	public var requestContext(default, null) : RequestContext;
	public var routeData(default, null) : RouteData;
	public var view(default, null) : IView;
	public var viewData(default, null) : Hash<Dynamic>; 
	public var request(default, null) : HttpRequest;
	public var response(default, null) : HttpResponse;
	public var session(default, null) : IHttpSessionState;

	public function new(controllerContext:ControllerContext, view:IView, viewData:Hash<Dynamic>)
	{                                         
		this.controller = controllerContext.controller;
		this.requestContext = controllerContext.requestContext; 
		this.httpContext = requestContext.httpContext;       
		this.routeData = requestContext.routeData;
		this.view = view;
		this.viewData = viewData;    
		
		this.request = httpContext.request;
		this.response = httpContext.response;        
		this.session = httpContext.session;
	}
}
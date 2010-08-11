package ufront.web.routing;
import ufront.web.HttpContext;

class RequestContext {
	public var httpContext(default, null) : HttpContext;
	public var routeData(default, null) : RouteData;
	public function new(httpContext : HttpContext, routeData : RouteData)
	{
		this.httpContext = httpContext;
		this.routeData = routeData;
	}
}
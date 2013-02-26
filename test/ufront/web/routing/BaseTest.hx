package ufront.web.routing;
import ufront.web.HttpRequestMock;
import ufront.web.HttpContextMock;
import ufront.web.HttpContext;
import ufront.web.mvc.MvcRouteHandler;

class BaseTest
{
	public function new(){}

	public function createRoute(url : String, ?constraint : IRouteConstraint, ?constraints : Array<IRouteConstraint>)
	{
		if(null == constraints)
			constraints = [];
		if(null != constraint)
			constraints.push(constraint);
		return new Route(url, new MvcRouteHandler(), constraints);
	}

	public function createContext(url : String) : HttpContext
	{
		var request = new HttpRequestMock();
		request.set_uri(url);
		var context = new HttpContextMock(request);
		return context;
	}
}
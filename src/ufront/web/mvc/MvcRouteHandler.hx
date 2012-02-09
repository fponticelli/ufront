package ufront.web.mvc;
import ufront.web.IHttpHandler;
import ufront.web.routing.RequestContext;
import ufront.web.routing.IRouteHandler;

class MvcRouteHandler implements IRouteHandler {
	public function new(){}

	public function getHttpHandler(requestContext : RequestContext) : IHttpHandler
	{
		return new MvcHandler(requestContext);
	}

}
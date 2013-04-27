package ufront.web.mvc;
import ufront.web.error.BadRequestError;
import thx.sys.Lib;
import thx.error.Error;
import ufront.web.HttpContext;
import ufront.web.routing.RequestContext;
import thx.error.NullArgument;
import ufront.web.IHttpHandler;

/** Selects the controller that will handle an HTTP request. 
*
* Ufront includes the following handler types:
* 
*     MvcHandler. This handler is responsible for initiating the pipeline for a Ufront application. It receives a Controller instance from the MVC controller factory; this controller handles further processing of the request. Note that even though MvcHandler implements IHttpHandler, it cannot be mapped as a handler (for example, to the .mvc file-name extension) because the class does not support a parameterless constructor. (Its only constructor requires a RequestContext object.)
* 
*     MvcRouteHandler. This class implements IRouteHandler, therefore it can integrate with Ufront routing. The MvcRouteHandler class associates the route with an MvcHandler instance. A MvcRouteHandler instance is registered with routing when you use the MapRoute method. When the MvcRouteHandler class is invoked, the class generates an MvcHandler instance using the current RequestContext instance. It then delegates control to the new MvcHandler instance.
* 
*     MvcHttpHandler. This handler is used to facilitate direct handler mapping without going through the routing module. This is useful if you want to map a file-name extension such as .mvc directly to an MVC handler. Internally, MvcHttpHandler performs the same tasks that ASP.NET routing ordinarily performs (going through MvcRouteHandler and MvcHandler). However, it performs these tasks as a handler instead of as a module. This handler is not typically used when the UrlRoutingModule is enabled for all requests.
*/
class MvcHandler implements IHttpHandler {

	/** Gets the request context. */
	public var requestContext(default, null) : RequestContext;

	@:isVar public var controllerBuilder(get, set) : ControllerBuilder;

	public function new(requestContext : RequestContext)
	{
		NullArgument.throwIfNull(requestContext);
    	this.requestContext = requestContext;
	}

	/** Processes the request by using the specified base HTTP request context. */
	public function processRequest(httpContext : HttpContext, async : hxevents.Async)
	{
		var controllerName = requestContext.routeData.getRequired("controller");
		var factory = controllerBuilder.get_controllerFactory();
		var controller = factory.createController(requestContext, controllerName);
		if(null == controller)
			throw new BadRequestError();
		try
		{
			controller.execute(requestContext, async);
		} catch(e : Dynamic) {
			factory.releaseController(controller);
			async.error(e);
		}
		factory.releaseController(controller);
	}

	function get_controllerBuilder() : ControllerBuilder
	{
		if(null == controllerBuilder)
			return ControllerBuilder.current;
		else
			return controllerBuilder;
	}

	function set_controllerBuilder(v : ControllerBuilder)
	{
		return controllerBuilder = v;
	}
}
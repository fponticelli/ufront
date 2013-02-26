package ufront.web.mvc;
import ufront.web.error.BadRequestError;
import thx.sys.Lib;
import thx.error.Error;
import ufront.web.HttpContext;
import ufront.web.routing.RequestContext;
import thx.error.NullArgument;
import ufront.web.IHttpHandler;

class MvcHandler implements IHttpHandler {
	public var requestContext(default, null) : RequestContext;
	@:isVar public var controllerBuilder(get, set) : ControllerBuilder;
	public function new(requestContext : RequestContext)
	{
		NullArgument.throwIfNull(requestContext);
    	this.requestContext = requestContext;
	}

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
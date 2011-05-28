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
	public var controllerBuilder(getControllerBuilder, setControllerBuilder) : ControllerBuilder;
	public function new(requestContext : RequestContext)
	{                            
		NullArgument.throwIfNull(requestContext);
    	this.requestContext = requestContext;
	}
	
	public function processRequest(httpContext : HttpContext, async : hxevents.Async)
	{                      
		var controllerName = requestContext.routeData.getRequired("controller");  
		var factory = controllerBuilder.getControllerFactory();
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
	
	function getControllerBuilder() : ControllerBuilder
	{
		if(null == controllerBuilder)
			return ControllerBuilder.current;
		else
			return controllerBuilder;
	}
	
	function setControllerBuilder(v : ControllerBuilder)
	{
		return controllerBuilder = v;
	}
}
package ufront.web.mvc;
import php.Lib;
import uform.util.Error;
import ufront.web.HttpContext;
import ufront.web.routing.RequestContext;
import udo.error.NullArgument;
import ufront.web.IHttpHandler;

class MvcHandler implements IHttpHandler {
	public var requestContext(default, null) : RequestContext;
	public var controllerBuilder(getControllerBuilder, setControllerBuilder) : ControllerBuilder;
	public function new(requestContext : RequestContext)
	{                            
		NullArgument.throwIfNull(requestContext, "requestContext");
    	this.requestContext = requestContext;
	}
	
	public function processRequest(httpContext : HttpContext)
	{                      
		var controllerName = requestContext.routeData.getRequired("controller");  
		var factory = controllerBuilder.getControllerFactory();
		var controller = factory.createController(requestContext, controllerName);
		if(null == controller)
			throw new Error("unable to load a controller for {0}", requestContext);
		try
		{
			controller.execute(requestContext);
		} catch(e : Dynamic) {
			factory.releaseController(controller);
			Lib.rethrow(e);
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
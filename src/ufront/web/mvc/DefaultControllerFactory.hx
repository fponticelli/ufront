package ufront.web.mvc;
import ufront.web.routing.RequestContext;
import udo.error.AbstractMethod;
import uform.util.Error;
import udo.error.NullArgument;

class DefaultControllerFactory implements IControllerFactory {
	var _controllerBuilder : ControllerBuilder;
	public function new(controllerBuilder : ControllerBuilder)
	{
		NullArgument.throwIfNull(controllerBuilder, "controllerBuilder");
		_controllerBuilder = controllerBuilder;
	}
	
	/**
	 *  @todo check on IController should be made before instantiating
	 */
	public function createController(requestContext : RequestContext, controllerName : String) : IController
	{
		for (pack in _controllerBuilder.packages())
		{
			var fullname = pack + "." + controllerName;
			var type = Type.resolveClass(fullname);
			if(null == type)
				continue;
			var controller = Type.createInstance(type, []);
			// TODO: this is bad, check should be made before instantiating 
			if(!Std.is(controller, IController))
				continue;
			return controller;
		}
		return throw new Error("unable to find a class for the controller {0}", controllerName);
	}
	
	public function releaseController(controller : IController)
	{
		if(Reflect.hasField(controller, "dispose"))
			Reflect.callMethod(controller, Reflect.field(controller, "dispose"), []);
	}
}
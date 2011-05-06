package ufront.web.mvc;
import ufront.web.routing.RequestContext;
import thx.error.AbstractMethod;
import thx.error.Error;
import thx.error.NullArgument;

class DefaultControllerFactory implements IControllerFactory {
	var _controllerBuilder : ControllerBuilder;
	var _dependencyResolver : IDependencyResolver;
	
	// TODO: IControllerActivator as ControllerBuilder
	public function new(controllerBuilder : ControllerBuilder, dependencyResolver : IDependencyResolver)
	{
		NullArgument.throwIfNull(controllerBuilder, "controllerBuilder");
		
		_controllerBuilder = controllerBuilder;
		_dependencyResolver = dependencyResolver;
	}
	
	public function createController(requestContext : RequestContext, controllerName : String) : IController
	{
	    var cls = Strings.ucfirst(controllerName);
		var names = [cls, cls + "Controller"];
		for (pack in _controllerBuilder.packages)
		{
			var type = null;
			while(null == type && names.length > 0)
				type = Type.resolveClass(pack + "." + names.pop());
			
			if (type != null)
			{
				var controller = _dependencyResolver.getService(type);
				if (Std.is(controller, IController)) return controller;
			}
		}
		return throw new Error("unable to find a class for the controller {0}", controllerName);
	}
	
	public function releaseController(controller : IController)
	{
		var f = Reflect.field(controller, "dispose");
		if(null != f)
			Reflect.callMethod(controller, f, []);
	}
}
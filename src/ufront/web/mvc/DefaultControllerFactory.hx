package ufront.web.mvc;
import thx.text.UString;
import thx.type.UType;
import ufront.web.routing.RequestContext;
import thx.error.AbstractMethod;
import thx.error.Error;
import thx.error.NullArgument;

class DefaultControllerFactory implements IControllerFactory {
	var _controllerBuilder : ControllerBuilder;
	public function new(controllerBuilder : ControllerBuilder)
	{
		NullArgument.throwIfNull(controllerBuilder, "controllerBuilder");
		_controllerBuilder = controllerBuilder;
	}
	
	public function createController(requestContext : RequestContext, controllerName : String) : IController
	{      
	    var cls = UString.ucfirst(controllerName);
		for (pack in _controllerBuilder.packages())
		{
			var fullname = pack + "." + cls;
			var type = Type.resolveClass(fullname);
			
			if (type != null)
			{
				var controller = Type.createInstance(type, []); // TODO: Dependency injection support
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
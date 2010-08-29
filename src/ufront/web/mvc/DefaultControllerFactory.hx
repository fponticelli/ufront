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
	
	/**
	 *  @todo check on IController should be made before instantiating
	 */
	public function createController(requestContext : RequestContext, controllerName : String) : Controller
	{      
	    var cls = UString.ucfirst(controllerName);
		for (pack in _controllerBuilder.packages())
		{
			var fullname = pack + "." + cls;
			var type = Type.resolveClass(fullname);
			if(null == type || !UType.hasSuperClass(type, Controller))
				continue; 
			return Type.createInstance(type, []);
		}
		return throw new Error("unable to find a class for the controller {0}", controllerName);
	}
	
	public function releaseController(controller : Controller)
	{
		var f = Reflect.field(controller, "dispose");
		if(null != f)
			Reflect.callMethod(controller, f, []);
	}
}
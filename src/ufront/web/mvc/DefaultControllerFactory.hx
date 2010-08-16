package ufront.web.mvc;
import udo.text.UString;
import udo.type.UType;
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
		if(Reflect.hasField(controller, "dispose"))
			Reflect.callMethod(controller, Reflect.field(controller, "dispose"), []);
	}
}
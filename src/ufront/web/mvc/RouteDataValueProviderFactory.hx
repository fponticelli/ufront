package ufront.web.mvc;
import thx.error.NullArgument;
import ufront.web.mvc.ControllerContext;
import ufront.web.mvc.IValueProvider;

/**
 * ...
 * @author Andreas Soderlund
 */

class RouteDataValueProviderFactory extends ValueProviderFactory
{
	public function new() 
	{
		super();
	}
	
	override public function getValueProvider(controllerContext : ControllerContext) : IValueProvider 
	{
		NullArgument.throwIfNull(controllerContext);
		return new RouteDataValueProvider(controllerContext);
	}
}
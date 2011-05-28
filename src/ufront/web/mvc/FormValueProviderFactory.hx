package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

import thx.error.NullArgument;
import ufront.web.mvc.ControllerContext;
import ufront.web.mvc.IValueProvider;

class FormValueProviderFactory extends ValueProviderFactory
{
	public function new() 
	{
		super();
	}
	
	override public function getValueProvider(controllerContext : ControllerContext) : IValueProvider 
	{
		NullArgument.throwIfNull(controllerContext);		
		return new FormValueProvider(controllerContext);
	}
}
package ufront.web.mvc;

/**
 * Represents a factory for creating value-provider objects. 
 * @author Andreas Soderlund
 */

class ValueProviderFactory 
{
	private function new() { }
	
	public function getValueProvider(controllerContext : ControllerContext) : IValueProvider
	{
		return throw "Abstract method, must be overridden in subclass.";
	}
}
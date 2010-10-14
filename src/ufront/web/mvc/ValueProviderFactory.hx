package ufront.web.mvc;

/**
 * ...
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
package ufront.web.mvc;

/**
 * Represents a value provider for query strings that are contained in a HashValueProvider object.
 * @author Andreas Soderlund
 */

class QueryStringValueProvider extends HashValueProvider<String>
{
	public function new(controllerContext : ControllerContext)
	{
		super(controllerContext.request.query);
	}	
}
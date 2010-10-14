package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

class QueryStringValueProvider extends HashValueProvider<String>
{
	public function new(controllerContext : ControllerContext)
	{
		super(controllerContext.request.query);
	}	
}
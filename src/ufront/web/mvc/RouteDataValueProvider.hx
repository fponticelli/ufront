package ufront.web.mvc;

/**
 * Represents a value provider for route data that is contained in a HashValueProvider object.
 * @author Andreas Soderlund
 */

class RouteDataValueProvider extends HashValueProvider<String>
{
	public function new(controllerContext : ControllerContext)
	{
		super(controllerContext.routeData.data);
	}	
}
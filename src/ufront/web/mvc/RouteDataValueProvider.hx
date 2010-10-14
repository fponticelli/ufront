package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

class RouteDataValueProvider extends HashValueProvider<String>
{
	public function new(controllerContext : ControllerContext)
	{
		super(controllerContext.routeData.data);
	}	
}
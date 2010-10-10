package ufront.web.routing;

/**
 * ...
 * @author Andreas Soderlund
 */

class RouteTable 
{
	static function __init__()
	{
		routes = new RouteCollection();
	}
	
	public static var routes(default, null) : RouteCollection;
}
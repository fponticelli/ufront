/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
import thx.error.AbstractMethod;
import ufront.web.HttpContext;
import ufront.web.routing.RequestContext;
import haxe.ds.StringMap;

/** Serves as the base class for all classes that represent a Ufront route. */
class RouteBase
{
	public var routes(default, null) : RouteCollection;

	/** When overridden in a derived class, returns route information about the request. */
	public function getRouteData(context : HttpContext) : RouteData
	{
		return null;
	}

	/** When overridden in a derived class, checks whether the route matches the specified values, and if so, generates a URL and retrieves information about the route. */
	public function getPath(context : HttpContext, data : StringMap<String>) : String
	{
		return null;
	}

	function setRoutes(routes : RouteCollection)
	{
		this.routes = routes;
	}
}
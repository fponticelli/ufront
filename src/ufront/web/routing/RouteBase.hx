/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
import thx.error.AbstractMethod;
import ufront.web.HttpContext;
import ufront.web.routing.RequestContext;

class RouteBase
{           
	public var routes(default, null) : RouteCollection;
	public function getRouteData(context : HttpContext) : RouteData
	{
		return null;
	} 
	
	public function getPath(context : HttpContext, data : Hash<String>) : String
	{
		return null;
	}
	
	function setRoutes(routes : RouteCollection)
	{
		this.routes = routes;
	}
}
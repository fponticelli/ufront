/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
import ufront.web.mvc.MvcRouteHandler;
import ufront.web.routing.IRouteConstraint;
import thx.collection.HashList;
import haxe.ds.StringMap;
using DynamicsT;

/** Provides a collection of routes for ASP.NET routing. */
class RouteCollection
{
	var _routes : Array<RouteBase>;

	public function new(?routes : Iterable<RouteBase>)
	{
		_routes = [];
		if(null != routes)
			for (route in routes)
				add(route);
	}

	/** Add a preconfigured route to the collection */
	public function add(route : RouteBase)
	{
		_routes.push(route);
		var r : { private function setRoutes(routes : RouteCollection) : Void; } = route;
		r.setRoutes(this);
		return this;
	}

	/** Add a route by defining the URI, defaults and constraints */
	public function addRoute(uri : String, ?defaults : Dynamic<String>, ?constraint : IRouteConstraint, ?constraints : Array<IRouteConstraint>)
	{
		if(null != constraint)
			constraints = [constraint];
		return add(
	   		new Route(
		    	uri,
				new MvcRouteHandler(),
				null == defaults ? null : defaults.toHash(),
				constraints));
	}

	public function iterator()
	{
		return _routes.iterator();
	}
}
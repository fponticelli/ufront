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

	public function add(route : RouteBase)
	{
		_routes.push(route);
		var r : { private function setRoutes(routes : RouteCollection) : Void; } = route;
		r.setRoutes(this);
		return this;
	}

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
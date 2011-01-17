/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
import ufront.web.mvc.MvcRouteHandler;
import ufront.web.routing.IRouteConstraint;
import thx.collections.HashList;     
using thx.util.UDynamicT; 

class RouteCollection
{
	var _routes : Array<RouteBase>;
	
	public function new(?routes : Array<RouteBase>)
	{
		_routes = (routes == null) ? [] : routes;
	}

	public function add(route : RouteBase)
	{
		_routes.push(route); 
		var r : { private function setRoutes(routes : RouteCollection) : Void; } = route;
		r.setRoutes(this);
		return this;
	}    
	
	public function addRoute(uri : String, ?defaults : Dynamic<String>, ?constraints : Array<IRouteConstraint>)
	{                                              
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
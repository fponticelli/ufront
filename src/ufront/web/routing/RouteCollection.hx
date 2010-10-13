/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
import ufront.web.mvc.MvcRouteHandler;
import ufront.web.routing.IRouteConstraint;
import thx.collections.HashList;     
import thx.collections.UHash; 

class RouteCollection
{
	var _routes : Array<RouteBase>;
	public function new()
	{
		_routes = [];
	}

	public function add(route : RouteBase)
	{
		_routes.push(route); 
		var r : { private function setRoutes(routes : RouteCollection) : Void; } = route;
		r.setRoutes(this);
	}    
	
	public function addRoute(uri : String, ?defaults : Dynamic<String>, ?constraints : Array<IRouteConstraint>)
	{                                              
		add(
	   		new Route(
		    	uri, 
				new MvcRouteHandler(),
				null == defaults ? null : UHash.createHash(defaults),
				constraints));
	}   
	
	public function iterator()
	{
		return _routes.iterator();
	}
}
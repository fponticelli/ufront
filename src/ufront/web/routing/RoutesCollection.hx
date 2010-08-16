/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
import ufront.web.mvc.MvcRouteHandler;
import ufront.web.routing.IRouteConstraint;
import udo.collections.HashList;     
import udo.collections.UHash; 

class RoutesCollection
{
	var _routes : Array<RouteBase>;
	public function new()
	{
		_routes = [];
	}

	public function add(route : RouteBase)
	{
		_routes.push(route);
	}    
	
	public function addRoute(uri : String, ?defaults : Dynamic<String>, ?constraints : Array<IRouteConstraint>)
	{                                              
		_routes.push(
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
/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.routing;
import udo.collections.HashList;

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
}
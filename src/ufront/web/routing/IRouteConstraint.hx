/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
import ufront.web.HttpContext;

interface IRouteConstraint
{
	public function match(context : HttpContext, route : Route, direction : RouteDirection) : Bool;
}
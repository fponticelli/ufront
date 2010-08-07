/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.routing;

interface IRouteConstraint
{
	public function match(context : HttpContext, route : Route, direction : RouteDirection) : Bool;
}
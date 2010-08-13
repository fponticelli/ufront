/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
import ufront.web.HttpContext;

interface IRouteConstraint
{
	public function match(context : HttpContext, route : Route, params : Hash<String>, direction : RouteDirection) : Bool;
}
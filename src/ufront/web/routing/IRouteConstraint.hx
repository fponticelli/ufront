/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
import ufront.web.HttpContext;
import ufront.web.UrlDirection;
import haxe.ds.StringMap;

interface IRouteConstraint
{
	public function match(context : HttpContext, route : Route, params : StringMap<String>, direction : UrlDirection) : Bool;
}
/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;

import haxe.ds.StringMap;
using Arrays;

/** Enables you to define which HTTP verbs are allowed when ASP.NET routing determines whether a URL matches a route. */
class HttpMethodConstraint implements IRouteConstraint
{
	/** Gets the collection of allowed HTTP verbs for the route. */
	public var methods(default, null) : Array<String>;

	public function new(?method : String, ?methods : Array<String>)
	{
		if (null == methods)
			methods = [];
		if (null != method)
			methods.push(method);
		if (0 == methods.length)
			throw "invalid argument, you have to pass at least one method";

		this.methods = methods.map(function(d) return d.toUpperCase());
	}

	/** Determines whether the request was made with an HTTP verb that is one of the allowed verbs for the route. */
	public function match(context : HttpContext, route : Route, params : StringMap<String>, direction : UrlDirection) : Bool
	{
		switch (direction) {
			case IncomingUrlRequest:
				return methods.exists(context.request.httpMethod);
			case UrlGeneration:
				return true;
		}
	}
}
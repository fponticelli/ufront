/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;

using Arrays;

class HttpMethodConstraint implements IRouteConstraint
{
	public var methods(default, null) : Array<String>;
	public function new(?method : String, ?methods : Array<String>)
	{
		if (null == methods)
			methods = [];
		if (null != method)
			methods.push(method);
		if (0 == methods.length)
			throw "invalid argument, you have to pass at least one method";

		this.methods = methods.map(function(d, _) return d.toUpperCase());
	}

	public function match(context : HttpContext, route : Route, params : Hash<String>, direction : UrlDirection) : Bool
	{
		switch (direction) {
			case IncomingUrlRequest:
				return methods.exists(context.request.httpMethod);
			case UrlGeneration:
				return true;
		}
	}
}
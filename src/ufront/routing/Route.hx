/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.routing;

class Route extends RouteBase
{
	public var url(default, null) : String;
	public var handler(default, null) : IRouteHandler;
	public var defaults(default, null) : Hash<RouteValueDefault>;
	public var constraints(default, null) : Iterable<RouteValueConstraint>;
	
	/**
	 *
	 * @todo add package prioritizing for controller matching
	 * @param	url
	 * @param	handler
	 * @param	?defaults
	 * @param	?constraints
	 */
	public function new(url : String, handler : IRouteHandler, ?defaults : Hash<RouteValueDefault>, ?constraints : Iterable<IRouteConstraint>)
	{
		if (null == url)
			throw "invalid null argument url";
		this.url = url;
		if (null == handler)
			throw "invalid null argument handler";
		this.handler = handler;
		if (null == defaults)
			this.defaults = new Hash();
		else
			this.defaults = defaults;
		if (null == constraints)
			this.constraints = [];
		else
			this.constraints = constraints;
	}
	
	public function processConstraints()
	{
		
	}
	
}
package ufront.web.routing;
import thx.error.Error;
import haxe.ds.StringMap;

/** Encapsulates information about a route. */
class RouteData {
	/** Gets the object that represents a route.*/
	public var route(default, null) : RouteBase;

	/** Gets or sets the object that processes a requested route. */
	public var routeHandler(default, null) : IRouteHandler;

	/** An object that contains values that are parsed from the URL and from default values. */
	public var data(default, null) : StringMap<String>;

	public function new(route : RouteBase, routeHandler : IRouteHandler, data : StringMap<String>)
	{
		this.route = route;
		this.routeHandler = routeHandler;
		this.data = data;
	}   
	
	/** Retrieves the value with the specified identifier, throws an error if it is not present. */
	public function getRequired(key : String)
	{
		if(data.exists(key))
			return data.get(key);
		else
			throw new Error("required parameter '{0} is missing'", key);
	}  
	
	/** Retrieves the value with the specified identifier. */
	public function get(key : String, ?alt : String)
	{
		var v = data.get(key);
		if(null == v)
			v = alt;
		return v;
	}
}
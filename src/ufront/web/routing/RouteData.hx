package ufront.web.routing;
import thx.error.Error;
import haxe.ds.StringMap;

class RouteData {
	public var route(default, null) : RouteBase;
	public var routeHandler(default, null) : IRouteHandler;
	public var data(default, null) : StringMap<String>;
	public function new(route : RouteBase, routeHandler : IRouteHandler, data : StringMap<String>)
	{
		this.route = route;
		this.routeHandler = routeHandler;
		this.data = data;
	}   
	
	public function getRequired(key : String)
	{
		if(data.exists(key))
			return data.get(key);
		else
			throw new Error("required parameter '{0} is missing'", key);
	}  
	
	public function get(key : String, ?alt : String)
	{
		var v = data.get(key);
		if(null == v)
			v = alt;
		return v;
	}
}
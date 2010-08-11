package ufront.web.routing;

class RouteData {
	public var route(default, null) : RouteBase;
	public var routeHandler(default, null) : IRouteHandler;
	public var data(default, null) : Hash<String>;
	public function new(route : RouteBase, routeHandler : IRouteHandler, data : Hash<String>)
	{
		this.route = route;
		this.routeHandler = routeHandler;
		this.data = data;
	}
}
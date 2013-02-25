package ufront.web.routing;

class EmptyRoute extends RouteBase
{    
	public static var instance(default, null) : RouteBase;
	public function new(){}  
	static function __init__() instance = new EmptyRoute();
}
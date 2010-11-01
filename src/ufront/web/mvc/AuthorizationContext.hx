package ufront.web.mvc;
import thx.collections.HashList;

class AuthorizationContext
{   
	public var actionName(default, null) : String;
	public var controllerContext(default, null) : ControllerContext;
	public var actionParameters(default, null) : HashList<Dynamic>;
	public var result : Dynamic;
	public function new(controllerContext : ControllerContext, actionName : String, arguments : HashList<Dynamic>)
	{
		this.controllerContext = controllerContext;
		this.actionName = actionName;
		this.actionParameters = arguments;
		this.result = null;
	}
}
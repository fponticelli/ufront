package ufront.web.mvc;

class ActionExecutedContext
{
	public var actionName(default, null) : String;
	public var controllerContext(default, null) : ControllerContext;
//	public var canceled : Bool;
//	public var exception : Dynamic
//  public var exceptionHandled : Bool;
	public var result : ActionResult;

	public function new(controllerContext : ControllerContext, actionName : String, result : ActionResult)
	{
		this.controllerContext = controllerContext;
		this.actionName = actionName;
//		canceled = false;
		this.result = result;
//		exceptionHandled = false;
	}
}
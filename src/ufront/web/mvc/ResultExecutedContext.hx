package ufront.web.mvc; 

/** Provides the context for the onResultExecuted method of (the equivalent of MVC2's ActionFilterAttribute) class. */
class ResultExecutedContext
{  
	/** Gets or sets the controller. */
	public var controllerContext(default, null) : ControllerContext;

	/** Gets or sets the action result. */
	public var result(default, null) : ActionResult;
	
	public function new(controllerContext : ControllerContext, result : ActionResult)
	{
		this.controllerContext = controllerContext;
		this.result = result;
	}	
}
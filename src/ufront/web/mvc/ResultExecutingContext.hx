package ufront.web.mvc; 

/** Provides the context for the OnResultExecuting method of the ActionFilterAttribute class. */
class ResultExecutingContext
{  
	public var controllerContext(default, null) : ControllerContext;
	public var result : ActionResult;
	
	public function new(controllerContext : ControllerContext, result : ActionResult)
	{
		/** Gets the controller context. */
		this.controllerContext = controllerContext;

		/** Gets or sets the action result. */
		this.result = result;
	}	
}
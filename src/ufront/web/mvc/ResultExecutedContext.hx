package ufront.web.mvc; 

class ResultExecutedContext
{  
	public var controllerContext(default, null) : ControllerContext;
	public var result(default, null) : ActionResult;
	
	public function new(controllerContext : ControllerContext, result : ActionResult)
	{
		this.controllerContext = controllerContext;
		this.result = result;
	}	
}
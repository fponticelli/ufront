package ufront.web.mvc; 

class ResultExecutingContext
{  
	public var controllerContext(default, null) : ControllerContext;
	public var result : ActionResult;
	
	public function new(controllerContext : ControllerContext, result : ActionResult)
	{
		this.controllerContext = controllerContext;
		this.result = result;
	}	
}
package ufront.web.mvc; 

class ResultExecutedContext
{  
	public var controllerContext(default, null) : ControllerContext;
	public var result(default, null) : Dynamic;
	public function new(controllerContext : ControllerContext, result : Dynamic)
	{
		this.controllerContext = controllerContext;
		this.result = result;
	}	
}
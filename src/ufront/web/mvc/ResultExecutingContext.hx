package ufront.web.mvc; 

class ResultExecutingContext
{  
	public var controllerContext(default, null) : ControllerContext;
	public var result : Dynamic;
	public function new(controllerContext : ControllerContext, result : Dynamic)
	{
		this.controllerContext = controllerContext;
		this.result = result;
	}	
}
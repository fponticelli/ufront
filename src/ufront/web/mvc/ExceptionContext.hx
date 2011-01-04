package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

class ExceptionContext extends ControllerContext
{
	public var exception : Dynamic;
	
	private var _result : ActionResult;
	public var result(getResult, setResult) : ActionResult;
		
	public function new(controllerContext : ControllerContext, exception : Dynamic)
	{
		super(controllerContext.controller, controllerContext.requestContext);
		this.exception = exception;
	}
	
	public function getResult()
	{
		return _result != null ? _result : new EmptyResult();
	}
	
	public function setResult(result : ActionResult)
	{
		_result = result;
		return result;
	}
}
package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

class ExceptionContext extends ControllerContext
{
	public var exception : Dynamic;
	public var exceptionHandled : Bool;
	
	public var result(getResult, setResult) : ActionResult;
	private var _result : ActionResult;
		
	public function new(controllerContext : ControllerContext, exception : Dynamic)
	{
		super(controllerContext.controller, controllerContext.requestContext);
		this.exception = exception;
	}
	
	function getResult()
	{
		return _result != null ? _result : new EmptyResult();
	}
	
	function setResult(result : ActionResult)
	{
		_result = result;
		return result;
	}
}
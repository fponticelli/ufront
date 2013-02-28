package ufront.web.mvc;

/**
 * Provides the context for using the HandleExceptionAttribute class.
 * @author Andreas Soderlund
 */

class ExceptionContext extends ControllerContext
{
	/** Gets or sets the exception object. */
	public var exception : Dynamic;

	/** Gets or sets a value that indicates whether the exception has been handled. */
	public var exceptionHandled : Bool;
	
	/** Gets or sets the action result. */
	public var result(get, set) : ActionResult;
	private var _result : ActionResult;
	
	// Initializes a new instance of the ExceptionContext class for the specified exception by using the specified controller context.
	public function new(controllerContext : ControllerContext, exception : Dynamic)
	{
		super(controllerContext.controller, controllerContext.requestContext);
		this.exception = exception;
	}
	
	function get_result()
	{
		return _result != null ? _result : new EmptyResult();
	}
	
	function set_result(result : ActionResult)
	{
		_result = result;
		return result;
	}
}
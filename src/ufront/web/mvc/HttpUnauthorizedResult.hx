package ufront.web.mvc;

/**
 * Represents the result of an unauthorized HTTP request. 
 * @author Andreas Soderlund
 */

class HttpUnauthorizedResult extends ActionResult
{
	public function new(){}
	
	override function executeResult(context : ControllerContext)
	{
		context.httpContext.response.status = 401;
	}
}
package ufront.web.mvc;

/**
 * ...
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
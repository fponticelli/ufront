//Url : String

package ufront.web.mvc;
import thx.error.NullArgument;

class RedirectResult extends ActionResult
{
	public var url : String;
	public var permanentRedirect : Bool;

	public function new(url : String, permanentRedirect = false)
	{
		NullArgument.throwIfNull(url);
		this.url = url;
		this.permanentRedirect = permanentRedirect;
	}

	override function executeResult(controllerContext : ControllerContext)
	{
		NullArgument.throwIfNull(controllerContext);
		controllerContext.response.clear();
        if(permanentRedirect)
			controllerContext.response.permanentRedirect(url);
		else
			controllerContext.response.redirect(url);
//		trace("redirect to " + controllerContext.response.isRedirect() + " " + controllerContext.response.redirectLocation);
	}
}
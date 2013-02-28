//Url : String

package ufront.web.mvc;
import thx.error.NullArgument;

/** Controls the processing of application actions by redirecting to a specified URI. */
class RedirectResult extends ActionResult
{
	/** Gets or sets the target URL. */
	public var url : String;

	/** Gets a value that indicates whether the redirection should be permanent. */
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
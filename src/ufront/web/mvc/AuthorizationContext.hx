package ufront.web.mvc;
import thx.collection.HashList;

/** Encapsulates the information that is required for using an AuthorizeAttribute attribute. */
class AuthorizationContext
{
	public var actionName(default, null) : String;
	public var controllerContext(default, null) : ControllerContext;
	public var actionParameters(default, null) : HashList<Dynamic>;

	/** Gets or sets the result that is returned by an action method. */
	public var result : ActionResult;

	public function new(controllerContext : ControllerContext, actionName : String, arguments : HashList<Dynamic>)
	{
		this.controllerContext = controllerContext;
		this.actionName = actionName;
		this.actionParameters = arguments;
		this.result = null;
	}
}
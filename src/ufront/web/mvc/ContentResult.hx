package ufront.web.mvc;
import thx.error.NullArgument;

class ContentResult extends ActionResult
{
	public var content : String;
	public var contentType : String;

	public function new(?content : String, ?contentType : String)
	{
		this.content = content;
		this.contentType = contentType;
	}

	override function executeResult(controllerContext : ControllerContext)
	{
		NullArgument.throwIfNull(controllerContext);

		if(null != contentType)
			controllerContext.response.contentType = contentType;

		controllerContext.response.write(content);
	}
}
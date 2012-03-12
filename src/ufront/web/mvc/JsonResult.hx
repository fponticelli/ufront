//ContentEncoding

package ufront.web.mvc;
import thx.json.Json;
import thx.error.NullArgument;

class JsonResult<T> extends ActionResult
{
	public var content : T;
	public var allowOrigin : String;

	public function new(content : T)
	{
		this.content = content;
	}

	override function executeResult(controllerContext : ControllerContext)
	{
		NullArgument.throwIfNull(controllerContext);

		controllerContext.response.contentType = "application/json";

		var serialized = Json.encode(content);

		controllerContext.response.write(serialized);
	}
}
//ContentEncoding

package ufront.web.mvc;
import thx.json.Json;
import thx.error.NullArgument;

class JsonPResult<T> extends ActionResult
{
	public var content : T;
	public var callbackName : String;

	public function new(content : T, callbackName : String)
	{
		this.content = content;
		this.callbackName = callbackName;
	}

	override function executeResult(controllerContext : ControllerContext)
	{
		NullArgument.throwIfNull(controllerContext);

		controllerContext.response.contentType = "text/javascript";

		var serialized = Json.encode(content);

		controllerContext.response.write(callbackName + "('" + serialized + "');");
	}

	public static function auto<T>(content : T, callbackName : String) : ActionResult
	{
		if(null == callbackName)
		{
			return new JsonResult(content);
		} else {
			return new JsonPResult(content, callbackName);
		}
	}
}
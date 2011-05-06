//ContentEncoding

package ufront.web.mvc;
import thx.json.Json;
import thx.error.NullArgument;

class JsonResult<T> extends ActionResult
{
	public var content : T;
	
	public function new(content : T)
	{
		this.content = content;
	}
	
	override function executeResult(controllerContext : ControllerContext)
	{
		NullArgument.throwIfNull(controllerContext, "controllerContext");

		controllerContext.response.contentType = "application/json";
		
		var serialized = Json.encode(content);
			
//		if(null != fileDownloadName)
//			controllerContext.response.setHeader("content-disposition", "attachment; filename=" + fileDownloadName);
//		controllerContext.response.writeBytes(content);
		controllerContext.response.write(serialized);
	}
}
package ufront.web.mvc;

import haxe.io.Bytes;
import thx.error.NullArgument;

class FileResult extends ActionResult
{
	public var contentType : String;
	public var fileDownloadName : String;
	
	function new(contentType : String, fileDownloadName : String)
	{
		this.contentType = contentType;
		this.fileDownloadName = fileDownloadName;
	}
	
	override function executeResult(controllerContext : ControllerContext)
	{
		NullArgument.throwIfNull(controllerContext, "controllerContext");

		if(null != contentType)
			controllerContext.response.contentType = contentType;
		
		if(null != fileDownloadName)
			controllerContext.response.setHeader("content-disposition", "attachment; filename=" + fileDownloadName);
	}
}
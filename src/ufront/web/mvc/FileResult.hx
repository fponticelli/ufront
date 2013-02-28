package ufront.web.mvc;

import haxe.io.Bytes;
import thx.error.NullArgument;

/** Represents a base class that is used to send binary file content to the response. */
class FileResult extends ActionResult
{
	/** Gets the content type to use for the response. */
	public var contentType : String;

	/** Gets or sets the content-disposition header so that a file-download dialog box is displayed in the browser with the specified file name. */
	public var fileDownloadName : String;
	
	function new(contentType : String, fileDownloadName : String)
	{
		this.contentType = contentType;
		this.fileDownloadName = fileDownloadName;
	}
	
	override function executeResult(controllerContext : ControllerContext)
	{
		NullArgument.throwIfNull(controllerContext);

		if(null != contentType)
			controllerContext.response.contentType = contentType;
		
		if(null != fileDownloadName)
			controllerContext.response.setHeader("content-disposition", "attachment; filename=" + fileDownloadName);
	}
}
package ufront.web.mvc;

class FileResult extends ActionResult
{
	public var content : Bytes;
	public var contentType : String;
	public var fileDownloadName : String;
	
	function new(content : Bytes, contentType : String, fileDownloadName : String)
	{
		this.content = content;
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
		controllerContext.response.writeBytes(content);
	}
}
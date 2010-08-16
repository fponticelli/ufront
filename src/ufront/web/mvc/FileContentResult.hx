package ufront.web.mvc;

class FileContentResult extends FileContent
{                                        
	public var fileContents : String;
	public function new(?fileContents : String, ?contentType : String, ?fileDownloadName)
	{             
		super(contentType, fileDownloadName);                                                                       
		this.fileContents = fileContents;
	}
	
	override function executeResult(controllerContext : ControllerContext)
	{   
		super(controllerContext);
		controllerContext.response.write(fileContents);
	}
}
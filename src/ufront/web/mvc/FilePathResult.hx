package ufront.web.mvc;
                           
import thx.neutral.io.File;

class FilePathResult extends FileContent
{     
	public var fileName : String;
	public function new(?fileName : String, ?contentType : String, ?fileDownloadName)
	{      
		super(contentType, fileDownloadName);
		this.fileName = fileName;
	}
	
	override function executeResult(controllerContext : ControllerContext)
	{   
		super(controllerContext);
		if(null != fileName)
			controllerContext.response.write(File.getContent(fileName));
	}
}
package ufront.web.mvc;
import haxe.io.Bytes;

class BytesResult extends FileResult
{                                        
	public var bytes : Bytes;
	public function new(?bytes : Bytes, ?contentType : String, ?fileDownloadName)
	{             
		super(contentType, fileDownloadName);                                                                       
		this.bytes = bytes;
	}
	
	override function executeResult(controllerContext : ControllerContext)
	{   
		super.executeResult(controllerContext);
		controllerContext.response.writeBytes(bytes, 0, bytes.length);
	}
}
package ufront.web.mvc;
                           
import haxe.io.Bytes;
import haxe.io.Eof;
import thx.sys.io.File;

class FilePathResult extends FileResult
{     
	static var BUF_SIZE = 4096;
	public var fileName : String;
	public function new(?fileName : String, ?contentType : String, ?fileDownloadName)
	{      
		super(contentType, fileDownloadName);
		this.fileName = fileName;
	}
	
	override function executeResult(controllerContext : ControllerContext)
	{   
		super.executeResult(controllerContext);
		if (null != fileName)
		{
			var reader = File.read(fileName, true);
			try
			{
				var buf = Bytes.alloc(BUF_SIZE);
				var size = reader.readBytes(buf, 0, BUF_SIZE);
				controllerContext.response.writeBytes(buf, 0, size);
			} catch (e : Eof) { }
		}
	}
}
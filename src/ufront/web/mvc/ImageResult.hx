package ufront.web.mvc;

import thx.error.NullArgument;
import uimage.IImage<Dynamic>;

/**
 * ...
 * @author Franco Ponticelli
 */

class ImageResult extends ActionResult
{
	public var format : ImageFormat;
	public var image : IImage<Dynamic>;

	public function new(image : IImage<Dynamic>, ?format : ImageFormat)
	{
		if (null == format)
			format = Png;
		this.format = format;
		NullArgument.throwIfNull(image, "image");
		this.image = image;
	}

	override function executeResult(controllerContext : ControllerContext)
	{
		NullArgument.throwIfNull(controllerContext, "controllerContext");
		var response = controllerContext.response;
		var bytes = switch(format)
		{
			case Jpeg:
				response.contentType = "image/jpeg";
				image.toBytesJpeg();
			case Png:
				response.contentType = "image/png";
				image.toBytesPng();
			case Gif:
				response.contentType = "image/gif";
				image.toBytesGif();
		}
		response.setHeader("Content-Length", "" + bytes.length);
//		response.setHeader("Last-Modified", DateTools.format(Date.now(), '%a, %d %b %Y %H:%M:%S') + ' GMT');
		response.writeBytes(bytes);
	}
}

enum ImageFormat
{
	Jpeg;
	Png;
	Gif;
}
package ufront.web.mvc; 

class HtmlViewResult extends ViewResult
{
	public var version : HtmlVersion;
	public var charset : String;
	public var language : String;
	
	public function new(?data : Hash<Dynamic>, ?version : HtmlVersion, language = "en", charset = "UTF-8")
	{
		super(data);
		this.version = null == version ? Html5 : version;
		this.language = language;
		this.charset = charset;
	}
		
	override function writeResponse(context : ControllerContext, content : String)
	{
		context.response.write(content);
	}
}

enum HtmlVersion
{
	Html4Strict;
	Html4Transitional;
	Html4Frameset;
	Html5;
	XHtml;
}
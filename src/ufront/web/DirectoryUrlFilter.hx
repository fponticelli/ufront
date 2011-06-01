package ufront.web;
import ufront.web.HttpRequest;
import thx.error.NullArgument;
import thx.error.Error;     

using StringTools;

class DirectoryUrlFilter implements IUrlFilter
{                                         
	public var directory(default, null) : String;
	var segments : Array<String>;
	public function new(directory : String)
	{
		if(directory.endsWith("/"))
			directory = directory.substr(0, directory.length-1);
		this.directory = directory;
		this.segments = directory.split("/");
	} 
	
	public function filterIn(url : PartialUrl, request : HttpRequest)
	{
		var pos = 0;
		while (url.segments.length > 0 && url.segments[0] == segments[pos++])
			url.segments.shift();
	}
	
	public function filterOut(url : VirtualUrl, request : HttpRequest)
	{
		url.segments = segments.concat(url.segments);
	}
}
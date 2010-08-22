package ufront.web;
import ufront.web.HttpRequest;
import udo.error.NullArgument;
import udo.error.Error;     

using StringTools;

class DirectoryUrlFilter implements IUrlFilter
{                                         
	public var directory(default, null) : String;
	public function new(directory : String)
	{
     	NullArgument.throwIfNull(directory, "directory");
		if(directory.endsWith("/"))
			directory = directory.substr(0, directory.length-1);
		this.directory = directory;
	} 
	
	public function filterIn(url : PartialUrl, request : HttpRequest)
	{        
		if(url.segments[0] == directory)
			url.segments.shift();
	}
	
	public function filterOut(url : VirtualUrl, request : HttpRequest)
	{       
		url.segments.unshift(directory);
	}
}
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
	
	public function filter(url : String, request : HttpRequest, direction : UrlDirection)
	{        
		switch(direction)
		{
			case IncomingUrlRequest:
				if(url.startsWith(directory))
					return url.substr(directory.length)
				else
					return url;
			case UrlGeneration:
				return url.startsWith('~') ? "~" + directory + url.substr(1) : directory + url;
		}
	}
}
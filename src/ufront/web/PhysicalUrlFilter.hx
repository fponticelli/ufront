package ufront.web;
import ufront.web.HttpRequest;
import udo.error.Error;     

using StringTools;

class PhysicalUrlFilter implements IUrlFilter
{       
	public function new()
	{

	} 
	
	public function filter(url : String, request : HttpRequest, direction : UrlDirection)
	{        
		switch(direction)
		{
			case IncomingUrlRequest:
				return url;
			case UrlGeneration:
				return url.startsWith('~') ? url.substr(1) : url;
		}
	}
}
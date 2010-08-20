package ufront.web;
import ufront.web.HttpRequest;
import udo.error.Error;     

using StringTools;

class PathInfoUrlFilter implements IUrlFilter
{       
	public var frontScript(default, null) : String;  
	public var useCleanRoot(default, null) : Bool;  
	public function new(?frontScript : String, useCleanRoot = true)
	{
		if(null == frontScript)
		{
			frontScript = #if php "/index.php" #elseif neko "/index.n" #else throw new Error("target not implemented, always pass a value for frontScript") #end;
		}                                                                                                                                                      
		this.frontScript = frontScript;        
		this.useCleanRoot = useCleanRoot;
	} 
	
	public function filter(url : String, request : HttpRequest, direction : UrlDirection)
	{        
		switch(direction)
		{
			case IncomingUrlRequest:
				if(url.startsWith(frontScript))
					return url.substr(frontScript.length);
				else
					return url;
			case UrlGeneration:  
				if(url.startsWith('~') || ("/" == url && useCleanRoot))
					return url;
				else
					return frontScript + url;
		}
	}
}
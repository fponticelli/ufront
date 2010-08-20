package ufront.web;
import ufront.web.HttpRequest;
import udo.error.Error;     

using StringTools;

class QueryStringUrlFilter implements IUrlFilter
{       
	public var frontScript(default, null) : String;
	public var paramName(default, null) : String; 
	public var useCleanRoot(default, null) : Bool;
	public function new(paramName = "q", ?frontScript : String, useCleanRoot = true)
	{
		if(null == frontScript)
		{
			frontScript = #if php "/index.php" #elseif neko "/index.n" #else throw new Error("target not implemented, always pass a value for frontScript") #end;
		}                                                                                                                                                      
		this.frontScript = frontScript; 
		this.paramName = paramName;       
		this.useCleanRoot = useCleanRoot;
	} 
	
	public function filter(url : String, request : HttpRequest, direction : UrlDirection)
	{        
		switch(direction)
		{
			case IncomingUrlRequest:  
				if(url == frontScript)
				{                       
					var params = request.query;       
					url = params.get(paramName);
					if(null == url)
						url = "/";
				   	else
						params.remove(paramName);
				}       
				return url;
			case UrlGeneration:  
				if(url.startsWith('~') || ("/" == url && useCleanRoot))
					return url;    
				else 
					return frontScript + (url.indexOf("?") >= 0 ? "&" : "?") + paramName + "=" + url;                            
		}
	}
}
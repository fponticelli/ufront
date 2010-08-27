package ufront.web;
import ufront.web.HttpRequest;
import thx.error.Error;     

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
			frontScript = #if php "index.php" #elseif neko "index.n" #else throw new Error("target not implemented, always pass a value for frontScript") #end;
		}                                                                                                                                                      
		this.frontScript = frontScript; 
		this.paramName = paramName;       
		this.useCleanRoot = useCleanRoot;
	} 
	
	public function filterIn(url : PartialUrl, request : HttpRequest)
	{     
		if(url.segments[0] == frontScript)
		{
		 	var params = request.query;     
		 	var u = params.get(paramName);
		 	if(null == u)
		 		url.segments = [];
		    else {
				url.segments = PartialUrl.parse(u).segments;
		 		params.remove(paramName);
	   		}
		}   
	} 
	
	public function filterOut(url : VirtualUrl, request : HttpRequest)
	{                       
		if(url.isPhysical || (url.segments.length == 0 && useCleanRoot)) {
		    //
		} else {   
			var path = "/" + url.segments.join("/");
			url.segments = [frontScript];
			url.query.set(paramName, { value : path, encoded : true }); 
   		}                                                              
	} 
}
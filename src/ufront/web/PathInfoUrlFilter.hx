package ufront.web;
import ufront.web.HttpRequest;
import thx.error.Error;     

using StringTools;

class PathInfoUrlFilter implements IUrlFilter
{       
	public var frontScript(default, null) : String;  
	public var useCleanRoot(default, null) : Bool;  
	public function new(?frontScript : String, useCleanRoot = true)
	{
		if(null == frontScript)
		{
			frontScript = #if php "index.php" #elseif neko "index.n" #else throw new Error("target not implemented, always pass a value for frontScript") #end;
		}                                                                                                                                                      
		this.frontScript = frontScript;        
		this.useCleanRoot = useCleanRoot;
	} 
	                                                            
	public function filterIn(url : PartialUrl, request : HttpRequest)
	{                                                           
		if(url.segments[0] == frontScript) 
		    url.segments.shift();                                                               
	}                                                           
	                                                            
	public function filterOut(url : VirtualUrl, request : HttpRequest)
	{          
		if(url.isPhysical || (url.segments.length == 0 && useCleanRoot)) {
		    //
		} else
		    url.segments.unshift(frontScript);                                                                      
	}
}
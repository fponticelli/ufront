package	ufront.web.routing;   

import ufront.web.routing.RouteUriParser;
import haxe.ds.StringMap;

using ufront.web.routing.RouteUriBuilder;

class RouteUriBuilder 
{                                        
	var ast : UriSegments;
	public function new(ast : UriSegments)
	{
		this.ast = ast;
	}                  
	
	public function build(params : StringMap<String>)
	{                          
		var buf = new StringBuf();

		for(segment in ast)
		{
			var s = buildSegment(segment, params); 
			if(null == s)
				return null;
			else if("" != s)
				buf.add("/" + s);
		}

		var result = buf.toString();
		if("" == result)
			return "/";
		else
			return result;
	}    
	
	function buildSegment(segment : UriSegment, params : StringMap<String>) 
	{       
		var result = "";
		for(part in segment.parts)
		{
			switch(part)
			{
				case UPConst(value):
					result += value;
				case UPParam(name): 
					if(!params.exists(name))
						return null;
				    result += params.getEncoded(name);
				case UPRest(name):  
					if(!params.exists(name))
						return null;
				    result += params.getRestEncoded(name);
				case UPOptParam(name):
				    if(params.exists(name))
						result += params.getEncoded(name);
				case UPOptRest(name):
				    if(params.exists(name))
						result += params.getRestEncoded(name);
				case UPOptLParam(name, left):
				    if(params.exists(name))
						result += left + params.getEncoded(name);
				case UPOptLRest(name, left):
					if(params.exists(name))
						result += left + params.getRestEncoded(name);
				case UPOptRParam(name, right):
				    if(params.exists(name))
						result += params.getEncoded(name) + right;
				case UPOptRRest(name, right):
					if(params.exists(name))
						result += params.getRestEncoded(name) + right;
				case UPOptBParam(name, left, right):
				    if(params.exists(name))
					result += left + params.getEncoded(name) + right;
				case UPOptBRest(name, left, right):
					if(params.exists(name))
						result += left + params.getRestEncoded(name) + right; 
			}
		}
		return result;
	}
	
	static inline function getEncoded(p : StringMap<String>, k : String)
	{
		var r = StringTools.urlEncode(p.get(k));   
		p.remove(k);
		return r;
	}  
	
	static function getRestEncoded(p : StringMap<String>, k : String)
	{         
		var parts = p.get(k).split("/");
		for(i in 0...parts.length)
			parts[i] = StringTools.urlEncode(parts[i]);
		var r = parts.join("/");
		p.remove(k);
		return r;
	}   
}
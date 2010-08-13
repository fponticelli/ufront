package	ufront.web.routing;   

import ufront.web.routing.RouteUriParser;

using ufront.web.routing.RouteUriBuilder;

class RouteUriBuilder 
{                                        
	var ast : UriSegments;
	public function new(ast : UriSegments)
	{
		this.ast = ast;
	}                  
	
	public function build(params : Hash<String>)
	{                             
		var buf = new StringBuf();
		
		for(segment in ast)
		{
			var s = buildSegment(segment, params);
			if("" != s)
				buf.add("/" + s);
		}
		
		var result = buf.toString();
		if("" == result)
			return "/";
		else
			return result;
	}    
	
	function buildSegment(segment : UriSegment, params : Hash<String>) 
	{       
		var result = "";
		for(part in segment.parts)
		{
			switch(part)
			{
				case UPConst(value):
					result += value;
				case UPParam(name):
				    result += params.getEncoded(name);
				case UPRest(name):
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
	
	static inline function getEncoded(p : Hash<String>, k : String)
	{
		return StringTools.urlEncode(p.get(k));
	}  
	
	static function getRestEncoded(p : Hash<String>, k : String)
	{         
		var parts = p.get(k).split("/");
		for(i in 0...parts.length)
			parts[i] = StringTools.urlEncode(parts[i]);
		return parts.join("/");
	}   
}
package ufront.web.routing;
import thx.error.NullArgument;
import thx.error.Error;
import ufront.web.routing.RouteUriParser;
import haxe.ds.StringMap;

using StringTools;
import thx.text.ERegs;

class RouteParamExtractor
{
	static inline var PARAM_PATTERN = "(.+?)";
	static inline var REST_PATTERN = "(.+?)";
	var ast : UriSegments;
	var data : StringMap<String>;
	public function new(ast : UriSegments)
	{
		NullArgument.throwIfNull(ast);
		this.ast = ast;
	}
	
	public function extract(uri : String) : StringMap<String>
	{
		NullArgument.throwIfNull(uri);
		var segments = uri.split("/");
		
		if(segments.length <= 1)
			throw new Error("the uri must begin with a '/' character");
		
		data = new StringMap();
		
		// discard first segment
		segments.shift();
		
		var segment = null;
		var patterns = ast.copy();
		while(true)
		{
			var pattern = patterns.shift();
			var isrest = null != pattern && pattern.rest;
			
			// set the next segment to analyze
			if(null != segment)
			{
				if(isrest)
			 		segment += "/" + segments.join("/");
			} else if(isrest)
			{
				segment = segments.join("/");
				segments = [];
			} else {
				segment = segments.shift();
			}
			
			if(null == segment)
			{
				if(null == pattern)
		  		// no more segments and patterns
					break;
	        	// we have a pattern but no more segments, the pattern must be optional
				if(pattern.optional)
					continue;
				else
					return null;
			} else if(null == pattern) {
				// still segments but no more patterns
				return null;
			}
			
    		if(tryExtractParts(segment, pattern.parts))
			{
				segment = null;
				continue;
  			} else if(pattern.optional) {
    			// try the same segment with the next pattern
  				continue;
   			} else
				return null;
		}
		return data;
	}
	
	function tryExtractParts(segment : String, parts : Array<UriPart>)
	{
		var pattern = buildPattern(parts);
		var re = new EReg(pattern.pattern, "");
		if(!re.match(segment))
			return false;
		
		for(i in 0...pattern.map.length)
		{
			var value = re.matched(i+1);
			if(null == value || "" == value)
				continue;
			data.set(pattern.map[i], value.urlDecode());
		}
		
		return true;
	}
	
	function buildPattern(parts : Array<UriPart>)
	{
		var pattern = new StringBuf();
		var map = [];
		pattern.add("^");
		for(i in 0...parts.length)
		{
			switch(parts[i])
			{
  				case UPConst(value):
   					if(0 == i)
						pattern.add(e(value));
					else
						pattern.add(r(value));
				case UPParam(name):
					map.push(name);
				    pattern.add(PARAM_PATTERN);
				case UPOptParam(name):
				    map.push(name);
				    pattern.add(PARAM_PATTERN + "?");
				case UPOptLParam(name, left):
					map.push(name);
			    	pattern.add("(?:" + l(left) + PARAM_PATTERN + ")?");
				case UPOptRParam(name, right):
					map.push(name);
		    		pattern.add("(?:" + PARAM_PATTERN + r(right) + ")?");
				case UPOptBParam(name, left, right):
					map.push(name);
	    			pattern.add("(?:" + l(left) + PARAM_PATTERN + r(right) + ")?");
				case UPRest(name):
					map.push(name);
				    pattern.add(REST_PATTERN);
				case UPOptRest(name):
				    map.push(name);
				    pattern.add(REST_PATTERN + "?");
				case UPOptLRest(name, left):
			    	map.push(name);
		    		pattern.add("(?:" + l(left) + PARAM_PATTERN + ")?");
				case UPOptRRest(name, right):
			     	map.push(name);
		    		pattern.add("(?:" + PARAM_PATTERN + r(right) + ")?");
				case UPOptBRest(name, left, right):
					map.push(name);
    				pattern.add("(?:" + l(left) + PARAM_PATTERN + r(right) + ")?");
			}
		}
	 	pattern.add("$");
		
		return { map : map, pattern : pattern.toString() };
	}
	
	inline function e(s : String)
	{
		return ERegs.escapeERegChars(s);
	}
	
	inline function r(s : String)
	{
		return e(s);
	}
	
	inline function l(s : String)
	{
		return e(s);
	}
}
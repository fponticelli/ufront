package ufront.web.routing;
import thx.collection.Set;
import thx.error.Error;
import thx.error.NullArgument;

class RouteUriParser
{
	static var constPattern = ~/^([^{]+)/;
	//add uppercase letters to allow routes with any case 
	static var paramPattern = ~/^\{([?$])?([*])?([a-zA-Z0-9_]+)(\?)?\}/;
	public function new(){}

	var restUsed : Bool;

	public function parse(uri : String, implicitOptionals : Set<String>) : UriSegments
	{
		NullArgument.throwIfNull(uri);
		var segments = uri.split("/");
		if(segments.length <= 1)
			throw new Error("a uri must start with a slash");

		var strip = segments.shift();
		if(strip.length > 0)
			throw new Error("there can't be anything before the first slash");

		restUsed = false;
		var capturedParams = new Set();
		var result = [];
		var segment;
		while(null != (segment = segments.shift()))
			result.push(_parseSegment(segment, segments, implicitOptionals, capturedParams));
		return result;
	}

	function _assembleSegment(stack : Array<UriPart>)
	{
		var parts = [];
		var optional = true;
		var rest = false;
		var last = stack.length - 1;
		var i = 0;
		while(i <= last)
		{
			var seg = stack[i];
			if(0 == i && i == last)
			{
				switch(seg)
				{
					case UPConst(_), UPParam(_):
					    parts.push(seg);
						optional = false;
					case UPRest(_):
						parts.push(seg);
						optional = false;
						rest = true;
					case UPOptParam(_):
						parts.push(seg);
					case UPOptRest(_):
					    parts.push(seg);
						rest = true;
					case UPOptLParam(name, _), UPOptRParam(name, _), UPOptBParam(name, _, _):
						parts.push(UPOptParam(name));
					case UPOptLRest(name, _), UPOptRRest(name, _), UPOptBRest(name, _, _):
						parts.push(UPOptRest(name));
						rest = true;
				}
			} else if(i == last)
			{
				switch(seg)
				{
					case UPConst(_), UPParam(_):
					    parts.push(seg);
						optional = false;
					case UPRest(_):
					    parts.push(seg);
						optional = false;
						rest = true;
					case UPOptParam(_):
					    parts.push(seg);
					case UPOptRest(_):
						parts.push(seg);
						rest = true;
					case UPOptLParam(name, left):
					    if(null == left)
							parts.push(UPOptParam(name))
						else
							parts.push(seg);
					case UPOptLRest(name, left):
					    if(null == left)
							parts.push(UPOptRest(name))
						else
							parts.push(seg);
						rest = true;
					case UPOptRParam(name, _):
						parts.push(UPOptParam(name));
					case UPOptBParam(name, left, _):
					    parts.push(UPOptLParam(name, left));
					case UPOptRRest(name, _):
						parts.push(UPOptRest(name));
						rest = true;
					case UPOptBRest(name, left, _):
						parts.push(UPOptLRest(name, left));
						rest = true;
				}
			} else {
				switch(seg)
				{
					case UPConst(value):
						switch(stack[i+1])
						{
							case UPOptLParam(name, _):
								parts.push(UPOptLParam(name, value));
								i++;
							case UPOptLRest(name, _):
								parts.push(UPOptLRest(name, value));
								i++;
								rest = true;
							case UPOptBParam(name, _, _):
								stack[i+1] = UPOptBParam(name, value, null);
							case UPOptBRest(name, _, _):
								stack[i+1] = UPOptBRest(name, value, null);
								rest = true;
							case UPConst(_), UPParam(_), UPOptParam(_), UPOptRParam(_, _):
							    parts.push(seg);
								optional = false;
							case UPRest(_), UPOptRest(_), UPOptRRest(_, _):
								parts.push(seg);
								optional = false;
								rest = true;
						}
					case UPParam(_):
						parts.push(seg);
						optional = false;
					case UPRest(_):
				     	parts.push(seg);
						optional = false;
						rest = true;
					case UPOptParam(_):
						parts.push(seg);
					case UPOptRest(_):
					   	parts.push(seg);
						rest = true;
					case UPOptLParam(name, left):
						if(null == left)
							parts.push(UPOptParam(name))
						else
							parts.push(seg);
					case UPOptRParam(name, _):
						switch(stack[i+1])
						{
							case UPConst(value):
								parts.push(UPOptRParam(name, value));
								i++;
							default:
								UPOptParam(name);
						}
					case UPOptBParam(name, left, _):
			          	switch(stack[i+1])
						{
							case UPConst(value):
								parts.push(UPOptBParam(name, left, value));
								i++;
							default:
								UPOptLParam(name, left);
						}
					case UPOptLRest(name, left):
						if(null == left)
							parts.push(UPOptRest(name))
						else
							parts.push(seg);
						rest = true;
					case UPOptRRest(name, _):
						switch(stack[i+1])
						{
							case UPConst(value):
								parts.push(UPOptRRest(name, value));
								i++;
							default:
								UPOptRest(name);
						}
						rest = true;
					case UPOptBRest(name, left, _):
						switch(stack[i+1])
						{
							case UPConst(value):
								parts.push(UPOptBRest(name, left, value));
								i++;
							default:
								UPOptLRest(name, left);
						}
						rest = true;
				}
			}
			i++;
		}

		if(parts.length == 0)
			optional = false;
		return { optional : optional, rest : rest, parts : parts };
	}

	function _parseSegment(segment : String, segments : Array<String>, implicitOptionals : Set<String>, capturedParams : Set<String>) : UriSegment
	{
		var stack = [];
		var seg = segment;
		while(seg.length > 0)
		{
			if(constPattern.match(seg))
			{
				stack.push(UPConst(constPattern.matched(1)));
				seg = constPattern.matchedRight();
			} else if (paramPattern.match(seg)) {
				var name = paramPattern.matched(3);

				if(capturedParams.exists(name))
					throw new Error("param '{0}' already used in path", name);
				else
					capturedParams.add(name);

				var isleftopt  = paramPattern.matched(1) == "?";
				var isrest     = paramPattern.matched(2) == "*";
			   	var isrightopt = paramPattern.matched(4) == "?";
				var isopt      = paramPattern.matched(1) == "$" || (!isleftopt && !isrightopt && implicitOptionals.exists(name));

				if(restUsed)
					throw new Error("there can be just one rest (*) parameter and it must be the last one");
				if(isrest)
				{
					restUsed = true;
					if(isleftopt && isrightopt) {
						stack.push(UPOptBRest(name, null, null));
					} else if(isleftopt) {
						stack.push(UPOptLRest(name, null));
					} else if(isrightopt) {
						stack.push(UPOptRRest(name, null));
					} else if(isopt) {
						stack.push(UPOptRest(name));
					} else {
						stack.push(UPRest(name));
					}
					seg = paramPattern.matchedRight() + reduceRestSegments(segments);
				} else {
					if(isleftopt && isrightopt) {
						stack.push(UPOptBParam(name, null, null));
		  			} else if(isleftopt) {
		  				stack.push(UPOptLParam(name, null));
		  	  		} else if(isrightopt) {
			  			stack.push(UPOptRParam(name, null));
			  		} else if(isopt) {
			  			stack.push(UPOptParam(name));
					} else {
						stack.push(UPParam(name));
					}
					seg = paramPattern.matchedRight();
				}
			} else {
				throw new Error("invalid uri segment '{0}'", seg);
			}
		}

		return _assembleSegment(stack);
	}

	static function reduceRestSegments(segments : Array<String>)
	{
		if(segments.length == 0)
			return "";
		var segment = "/" + segments.join("/");
		while(segments.length > 0)
			segments.pop();
	   	return segment;
	}

}

typedef UriSegments = Array<UriSegment>;
typedef UriSegment  = { optional : Bool, rest : Bool, parts : Array<UriPart>};

enum UriPart
{
	UPConst(value : String);
	UPParam(name : String);
	UPOptParam(name : String);
	UPOptLParam(name : String, left : String);
	UPOptRParam(name : String, right : String);
	UPOptBParam(name : String, left : String, right : String);
	UPRest(name : String);
	UPOptRest(name : String);
	UPOptLRest(name : String, left : String);
	UPOptRRest(name : String, right : String);
	UPOptBRest(name : String, left : String, right : String);
}
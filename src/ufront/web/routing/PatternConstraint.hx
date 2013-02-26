/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
import ufront.web.UrlDirection;

import ufront.web.HttpContext;
import thx.error.NullArgument;
import haxe.ds.StringMap;

class PatternConstraint implements IRouteConstraint
{
	var parameterName : String;
	var pattern(default, null) : EReg;
	var validateDefault : Bool;
	public function new(parametername : String, pattern : String, options = "", validatedefault = false)
	{
		NullArgument.throwIfNull(parametername);
		NullArgument.throwIfNull(pattern);
		NullArgument.throwIfNull(options);
		this.parameterName = parametername;
		this.pattern = new EReg(pattern, options);
		this.validateDefault = validatedefault;
	}

	public function match(context : HttpContext, route : Route, params : StringMap<String>, direction : UrlDirection) : Bool
	{
		var value = params.get(parameterName);
		if(null == value && validateDefault)
			value = route.defaults.get(parameterName);
		if(null == value)
			return true;
		return pattern.match(value);
	}
}
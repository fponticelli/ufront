/**
 * ...
 * @author Franco Ponticelli
 */
                            
package ufront.web.routing; 

import ufront.web.HttpContext;  
import udo.error.NullArgument;

class PatternConstraint implements IRouteConstraint
{         
	var parameterName : String;
	var pattern(default, null) : EReg; 
	var validateDefault : Bool;
	public function new(parametername : String, pattern : String, options = "", validatedefault = false)
	{
		NullArgument.throwIfNull(parametername, "parametername");
		NullArgument.throwIfNull(pattern, "pattern");
		NullArgument.throwIfNull(options, "options");
		this.parameterName = parametername;        
		this.pattern = new EReg(pattern, options);
		this.validateDefault = validatedefault;
	}
	
	public function match(context : HttpContext, route : Route, params : Hash<String>, direction : RouteDirection) : Bool
	{
		var value = params.get(parameterName);  
		if(null == value && validateDefault)       
			value = route.defaults.get(parameterName);
		if(null == value)
			return true;       
		return pattern.match(value);
	}
}
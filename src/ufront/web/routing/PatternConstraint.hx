/**
 * Checks if a Route parameter (one of the variables you capture) matches a regular expression.
 *
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

	/**
	* Construct a new PatternConstraint
	*
	* @param parameterName - the name of the captured parameter/variable that you wish to check
	* @param pattern - the regular expression pattern
	* @param options - any flags/options for your regular expression.
	* @param validateDefault - if the parameter wasn't there, and you are relying on the default, do
	*   you still want to validate it?
	*/
	public function new(parametername : String, pattern : String, options = "", validatedefault = false)
	{
		NullArgument.throwIfNull(parametername);
		NullArgument.throwIfNull(pattern);
		NullArgument.throwIfNull(options);
		this.parameterName = parametername;
		this.pattern = new EReg(pattern, options);
		this.validateDefault = validatedefault;
	}

	/**
	* This will be called by the route during getRouteData to see if the route passes this constraint.
	*
	* If your requested parameter matches the regular expression, it will pass.  If the parameter is null, and
	* you have asked to validate the defaults, then the it will check your default value passes.  If you don't
	* ask to validate the defaults, and it is null, then it will assume the default value is okay it will pass.
	*/
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
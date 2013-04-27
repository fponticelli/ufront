/**
 * Checks if a Route parameter (one of the variables you capture) matches a given list of allowed values
 * .
 * @author Franco Ponticelli
 */

package ufront.web.routing;
using Arrays;
import ufront.web.UrlDirection;
import ufront.web.HttpContext;
import thx.error.NullArgument;
import haxe.ds.StringMap;

class ValuesConstraint implements IRouteConstraint
{
	var parameterName : String;
	var values(default, null) : Array<String>;
	var validateDefault : Bool;
	var caseInsesitive : Bool;

	/**
	* Construct a new ValuesConstraint
	*
	* @param parameterName - the name of the captured parameter/variable that you wish to check
	* @param values - this list of allowable values you wish to check against
	* @param caseInsensitive - Is it alright if the values 
	* @param validateDefault - if the parameter wasn't there, and you are relying on the default, do
	*   you still want to validate it?
	*/
	public function new(parametername : String, values : Array<String>, caseInsesitive = false, validatedefault = false)
	{
		NullArgument.throwIfNull(parametername);
		NullArgument.throwIfNull(values);
		this.parameterName = parametername;
		if(caseInsesitive)
		{
			this.values = values.map(function(d) return d.toLowerCase());
		} else {
			this.values = values;
		}
		this.caseInsesitive = caseInsesitive;
		this.validateDefault = validatedefault;
	}

	/**
	* This will be called by the route during getRouteData to see if the route passes this constraint.
	*
	* If your requested parameter matches one of the allowed values, it will pass.  If the parameter is null, and
	* you have asked to validate the defaults, then the it will check your default value passes.  If you don't
	* ask to validate the defaults, and it is null, then it will assume the default value is okay and it will pass.
	*/
	public function match(context : HttpContext, route : Route, params : StringMap<String>, direction : UrlDirection) : Bool
	{
		var value = params.get(parameterName);
		if(null == value && validateDefault)
			value = route.defaults.get(parameterName);
		if(null == value)
			return true;
		return values.exists(value.toLowerCase());
	}
}
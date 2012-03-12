/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
using Arrays;
import ufront.web.UrlDirection;
import ufront.web.HttpContext;
import thx.error.NullArgument;

class ValuesConstraint implements IRouteConstraint
{
	var parameterName : String;
	var values(default, null) : Array<String>;
	var validateDefault : Bool;
	var caseInsesitive : Bool;
	public function new(parametername : String, values : Array<String>, caseInsesitive = false, validatedefault = false)
	{
		NullArgument.throwIfNull(parametername);
		NullArgument.throwIfNull(values);
		this.parameterName = parametername;
		if(caseInsesitive)
		{
			this.values = values.map(function(d, _) return d.toLowerCase());
		} else {
			this.values = values;
		}
		this.caseInsesitive = caseInsesitive;
		this.validateDefault = validatedefault;
	}

	public function match(context : HttpContext, route : Route, params : Hash<String>, direction : UrlDirection) : Bool
	{
		var value = params.get(parameterName);
		if(null == value && validateDefault)
			value = route.defaults.get(parameterName);
		if(null == value)
			return true;
		return values.exists(value.toLowerCase());
	}
}
/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;     

import ufront.web.HttpContext;

class ParameterConstraint implements IRouteConstraint
{
	public var parameterName(default, null) : String;
	public function new(parametername : String)
	{
		if (null == parametername)
			throw "invalid null argument parametername";
		this.parameterName = parametername;
	}
	
	override public function match(context : HttpContext, route : Route) : Bool
	{
		return throw "abstract method";
	}
}
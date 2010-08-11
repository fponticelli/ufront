/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.routing;

class PatternConstraint extends ParameterConstraint
{
	var pattern(default, null) : EReg;
	public function new(parametername : String, pattern : String, options = "")
	{
		super(parametername);
		if (null == pattern)
			throw "invalid null argument pattern";
		if (null == options)
			throw "invalid null argument options";
		this.pattern = new EReg(pattern, options);
	}
	
	override public function match(context : HttpContext, route : Route) : Bool
	{
		return throw "not implemented";
	}
}
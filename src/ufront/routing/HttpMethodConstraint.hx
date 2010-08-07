/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.routing;

class HttpMethodConstraint implements IRouteConstraint
{
	public var methods(default, null) : Array<String>;
	public function new(?method : String, ?methods : Array<String>)
	{
		if (null == methods)
			methods = [];
		if (null != method)
			methods.push(method);
		if (0 == methods.length)
			throw "invalid argument, you have to pass at least one method";
			
		this.methods = methods;
	}
	
}
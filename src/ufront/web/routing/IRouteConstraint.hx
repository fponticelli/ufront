/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
import ufront.web.HttpContext;
import ufront.web.UrlDirection;
import haxe.ds.StringMap;

/** 
* Defines the contract that a class must implement in order to check whether a URL parameter value is valid for a constraint.
*
* See PatternConstraint, ValuesConstraint and HttpMethodCOnstraint for common implementations.
*/
interface IRouteConstraint
{
	/** 
	* Determines whether the URL parameter contains a valid value for this constraint.
	*
	* @param An object that encapsulates information about the HTTP request.
	* @param The object that this constraint belongs to.
	* @param The parameters extracted from the URL
	* @param Either IncomingUrlRequest or UrlGeneration
	*/
	public function match(context : HttpContext, route : Route, params : StringMap<String>, direction : UrlDirection) : Bool;
}
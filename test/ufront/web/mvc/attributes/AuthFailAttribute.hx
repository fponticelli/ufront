package ufront.web.mvc.attributes;
import ufront.web.mvc.AuthorizationContext;
import ufront.web.mvc.attributes.FilterAttribute;
import ufront.web.mvc.IAuthorizationFilter;
import ufront.web.mvc.TestControllerFiltersMetaData;

/**
 * ...
 * @author Andreas Soderlund
 */

class AuthFailAttribute extends FilterAttribute implements IAuthorizationFilter
{
	public function new() {	super(); }
	
	public function onAuthorization(filterContext : AuthorizationContext)
	{
		var c = cast(filterContext.controllerContext.controller, BaseTestController);
		
		c.sequence.push("onAuthorization");		
		filterContext.result = new SequenceResult(c, "AuthFail");
	}	
}
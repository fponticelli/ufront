package ufront.web.mvc.attributes;

import ufront.web.mvc.AuthorizationContext;
import ufront.web.mvc.ExceptionContext;
import ufront.web.mvc.attributes.FilterAttribute;
import ufront.web.mvc.IExceptionFilter;
import ufront.web.mvc.TestControllerFiltersMetaData;

/**
 * ...
 * @author Andreas Soderlund
 */

class HandleExceptionAttribute extends FilterAttribute implements IExceptionFilter
{
	// If the exception should tell that it's handling the situation
	public var handleIt : Bool;
	
	public function new()
	{	
		handleIt = false;
		super(); 
	}
	
	public function onException(filterContext : ExceptionContext)
	{
		var c = cast(filterContext.controller, BaseTestController);
		c.sequence.push("onException");
		
		filterContext.result = new SequenceResult(c, "ExceptionHandler for " + Std.string(filterContext.exception));
		filterContext.exceptionHandled = handleIt;
	}	
}
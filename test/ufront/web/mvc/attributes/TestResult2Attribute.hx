package ufront.web.mvc.attributes;

import ufront.web.mvc.IResultFilter;
import ufront.web.mvc.ResultExecutedContext;
import ufront.web.mvc.ResultExecutingContext;
import ufront.web.mvc.TestControllerFiltersMetaData;

/**
 * ...
 * @author Andreas Soderlund
 */

class TestResult2Attribute extends FilterAttribute implements IResultFilter
{
	public function new()
	{
		super();
	}
	
	public function onResultExecuting(filterContext : ResultExecutingContext) : Void
	{
		var c = cast(filterContext.controllerContext.controller, BaseTestController);
		c.sequence.push('result2 executing');
	}
	
	public function onResultExecuted(filterContext : ResultExecutedContext) : Void
	{
		var c = cast(filterContext.controllerContext.controller, BaseTestController);
		c.sequence.push('result2 executed');
	}
}

package ufront.web.mvc.attributes;

import ufront.web.mvc.ActionExecutedContext;
import ufront.web.mvc.IActionFilter;
import ufront.web.mvc.TestControllerFiltersMetaData;

/**
 * ...
 * @author Andreas Soderlund
 */

class TestActionAttribute extends FilterAttribute, implements IActionFilter
{
	public function onActionExecuting(filterContext : ActionExecutingContext) : Void
	{
		var c = cast(filterContext.controllerContext.controller, BaseTestController);
		c.sequence.push('executing');
	}
	
	public function onActionExecuted(filterContext : ActionExecutedContext) : Void
	{
		var c = cast(filterContext.controllerContext.controller, BaseTestController);
		c.sequence.push('executed');		
	}
}

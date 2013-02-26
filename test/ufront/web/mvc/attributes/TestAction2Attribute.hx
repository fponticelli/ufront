package ufront.web.mvc.attributes;

import ufront.web.mvc.ActionExecutedContext;
import ufront.web.mvc.IActionFilter;
import ufront.web.mvc.TestControllerFiltersMetaData;
import ufront.web.mvc.attributes.FilterAttribute;

/**
 * ...
 * @author Andreas Soderlund
 */

class TestAction2Attribute extends FilterAttribute implements IActionFilter
{
	public function new()
	{
		super();
	}
	
	public function onActionExecuting(filterContext : ActionExecutingContext) : Void
	{
		var c = cast(filterContext.controllerContext.controller, BaseTestController);
		c.sequence.push('executing2');
	}
	
	public function onActionExecuted(filterContext : ActionExecutedContext) : Void
	{
		var c = cast(filterContext.controllerContext.controller, BaseTestController);
		c.sequence.push('executed2');
	}
}

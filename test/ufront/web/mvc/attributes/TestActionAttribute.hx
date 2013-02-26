package ufront.web.mvc.attributes;

import ufront.web.mvc.ActionExecutedContext;
import ufront.web.mvc.IActionFilter;
import ufront.web.mvc.TestControllerFiltersMetaData;

/**
 * ...
 * @author Andreas Soderlund
 */

class TestActionAttribute extends FilterAttribute implements IActionFilter
{
	public var id : String;
	
	public function new()
	{
		this.id = "";
		super();
	}
	
	public function onActionExecuting(filterContext : ActionExecutingContext) : Void
	{
		var c = cast(filterContext.controllerContext.controller, BaseTestController);
		c.sequence.push('executing' + id);
	}
	
	public function onActionExecuted(filterContext : ActionExecutedContext) : Void
	{
		var c = cast(filterContext.controllerContext.controller, BaseTestController);
		c.sequence.push('executed' + id);
	}
}

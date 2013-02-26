package ufront.web.mvc.attributes;

import ufront.web.mvc.IResultFilter;
import ufront.web.mvc.ResultExecutedContext;
import ufront.web.mvc.ResultExecutingContext;
import ufront.web.mvc.TestControllerFiltersMetaData;

/**
 * ...
 * @author Andreas Soderlund
 */

class TestResultAttribute extends FilterAttribute implements IResultFilter
{
	public var id : String;
	
	public function new()
	{
		this.id = "";
		super();
	}
	
	public function onResultExecuting(filterContext : ResultExecutingContext) : Void
	{
		var c = cast(filterContext.controllerContext.controller, BaseTestController);
		c.sequence.push('result executing' + id);
	}
	
	public function onResultExecuted(filterContext : ResultExecutedContext) : Void
	{
		var c = cast(filterContext.controllerContext.controller, BaseTestController);
		c.sequence.push('result executed' + id);
	}
}

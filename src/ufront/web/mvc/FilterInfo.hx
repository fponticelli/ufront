package ufront.web.mvc;

import ufront.web.mvc.attributes.FilterAttribute;

/**
 * ...
 * @author Andreas Soderlund
 */

class FilterInfo 
{
	public var authorizationFilters(default, null) : Array<IAuthorizationFilter>;
	public var actionFilters(default, null) : Array<IActionFilter>;
	public var exceptionFilters(default, null) : Array<IExceptionFilter>;
	public var resultFilters(default, null) : Array<IResultFilter>;

	public function new(filters : Iterable<FilterAttribute>)
	{
		authorizationFilters = [];
		actionFilters = [];
		exceptionFilters = [];
		resultFilters = [];
		
		if (filters != null)
			addFilters(filters);
	}
	
	public function addFilters(filters : Iterable<FilterAttribute>)
	{
		for (filter in filters)
			addFilter(filter);
	}
	
	public function addFilter(attribute : FilterAttribute) : Void
	{
		if (Std.is(attribute, IAuthorizationFilter))
			authorizationFilters.push(cast attribute);
			
		if (Std.is(attribute, IActionFilter))
			actionFilters.push(cast attribute);
			
		if (Std.is(attribute, IResultFilter))
			resultFilters.push(cast attribute);
			
		if (Std.is(attribute, IExceptionFilter))
			exceptionFilters.push(cast attribute);
	}
	
	public function mergeControllerFilters(controller : IController) : Void 
	{
		if (Std.is(controller, IAuthorizationFilter))
			authorizationFilters.unshift(cast controller);
			
		if (Std.is(controller, IActionFilter))
			actionFilters.unshift(cast controller);

		if (Std.is(controller, IResultFilter))
			resultFilters.unshift(cast controller);

		if (Std.is(controller, IExceptionFilter))
			exceptionFilters.unshift(cast controller);
	}
}
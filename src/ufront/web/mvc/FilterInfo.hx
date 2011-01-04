package ufront.web.mvc;

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

	public function new() 
	{
		authorizationFilters = [];
		actionFilters = [];
		exceptionFilters = [];
		resultFilters = [];
	}
}
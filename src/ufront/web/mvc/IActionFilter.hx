package ufront.web.mvc;

import hxevents.Dispatcher;

interface IActionFilter
{
	public var onActionExecuted(default, null) : Dispatcher<ActionExecutedContext>;
	public var onActionExecuting(default, null) : Dispatcher<ActionExecutingContext>;
}
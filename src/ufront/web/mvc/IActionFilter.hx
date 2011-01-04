package ufront.web.mvc;

import hxevents.Dispatcher;
import ufront.events.ReverseDispatcher;

interface IActionFilter
{
	function onActionExecuting(filterContext : ActionExecutingContext) : Void;
	function onActionExecuted(filterContext : ActionExecutedContext) : Void;
}
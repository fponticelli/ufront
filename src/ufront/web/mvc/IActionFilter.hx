package ufront.web.mvc;

import hxevents.Dispatcher;
import ufront.events.ReverseDispatcher;

/** Defines the methods that are used in an action filter. */
interface IActionFilter
{
	function onActionExecuting(filterContext : ActionExecutingContext) : Void;
	function onActionExecuted(filterContext : ActionExecutedContext) : Void;
}
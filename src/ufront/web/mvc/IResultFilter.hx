package ufront.web.mvc;

/** Defines the methods that are required for a result filter. */
interface IResultFilter
{
	function onResultExecuting(filterContext : ResultExecutingContext) : Void;
	function onResultExecuted(filterContext : ResultExecutedContext) : Void;
}
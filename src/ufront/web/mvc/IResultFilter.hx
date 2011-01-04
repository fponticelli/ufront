package ufront.web.mvc;

interface IResultFilter
{
	function onResultExecuting(filterContext : ResultExecutingContext) : Void;
	function onResultExecuted(filterContext : ResultExecutedContext) : Void;
}
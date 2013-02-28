package ufront.web.mvc;

/** Defines the methods that are required for an exception filter. */
interface IExceptionFilter 
{
	function onException(filterContext : ExceptionContext) : Void;
}
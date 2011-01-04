package ufront.web.mvc;

interface IExceptionFilter 
{
	function onException(filterContext : ExceptionContext) : Void;
}
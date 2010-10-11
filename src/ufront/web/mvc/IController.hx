package ufront.web.mvc;
import ufront.web.routing.RequestContext;

interface IController 
{
	function execute(requestContext : RequestContext) : Void;
}
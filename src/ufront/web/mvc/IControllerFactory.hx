package ufront.web.mvc;
import ufront.web.routing.RequestContext;

interface IControllerFactory 
{
	public function createController(requestContext : RequestContext, controllerName : String) : Controller; 
	public function releaseController(controller : Controller) : Void;
}
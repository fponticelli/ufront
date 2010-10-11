package ufront.web.mvc;
import ufront.web.routing.RequestContext;

interface IControllerFactory 
{
	public function createController(requestContext : RequestContext, controllerName : String) : IController;
	public function releaseController(controller : IController) : Void;
}
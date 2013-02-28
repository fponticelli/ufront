package ufront.web.mvc;
import ufront.web.routing.RequestContext;

/** Provides fine-grained control over how controllers are instantiated using dependency injection. */
interface IControllerFactory 
{
	public function createController(requestContext : RequestContext, controllerName : String) : IController;
	public function releaseController(controller : IController) : Void;
}
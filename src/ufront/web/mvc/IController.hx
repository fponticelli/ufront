package ufront.web.mvc;
import ufront.web.routing.RequestContext;

/** Defines the methods that are required for a controller. */
interface IController
{
	public function execute(requestContext : RequestContext, async : hxevents.Async) : Void;
	public function getViewHelpers() : Array<IViewHelper>;
}
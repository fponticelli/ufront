package ufront.web.mvc;
import ufront.web.routing.RequestContext;

interface IController
{
	public function execute(requestContext : RequestContext, async : hxevents.Async) : Void;
	public function getViewHelpers() : Array<IViewHelper>;
}
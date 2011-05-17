package ufront.web.mvc.test;
import ufront.web.routing.RequestContext;
import ufront.web.mvc.Controller;

class MockController extends Controller {
	public var disposed : Bool;
	public function new()
	{       
		super();
		disposed = false;
	}
	
	override function execute(requestContext : RequestContext, async : hxevents.Async) : Void{}
}
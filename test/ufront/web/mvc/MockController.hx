package ufront.web.mvc;
import ufront.web.routing.RequestContext;
import ufront.web.mvc.Controller;

class MockController extends Controller {
	public var disposed : Bool;
	public function new()
	{        
		super();
		disposed = false;
	}
	
	public function dispose()
	{
		if(disposed)
			throw "already disposed";
		disposed = true;
	}
	
	override function execute(requestContext : RequestContext, async : hxevents.Async) : Void{}
}
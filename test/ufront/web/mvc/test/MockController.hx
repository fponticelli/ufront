package ufront.web.mvc.test;
import ufront.web.routing.RequestContext;
import ufront.web.mvc.IController;

class MockController implements IController {
	public var disposed : Bool;
	public function new()
	{
		disposed = false;
	}
	
	public function execute(requestContext : RequestContext) : Void;
}
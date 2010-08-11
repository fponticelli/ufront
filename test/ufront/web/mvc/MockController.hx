package ufront.web.mvc;
import ufront.web.routing.RequestContext;
import ufront.web.mvc.IController;

class MockController implements IController {
	public var disposed : Bool;
	public function new()
	{
		disposed = false;
	}
	
	public function dispose()
	{
		if(disposed)
			throw "already disposed";
		disposed = true;
	}
	
	public function execute(requestContext : RequestContext) : Void;
}
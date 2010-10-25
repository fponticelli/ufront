package ufront.web.mvc;              
import ufront.web.error.PageNotFoundError;
import ufront.web.HttpContext;
import thx.error.Error;
import ufront.web.routing.RequestContext;
import ufront.web.mvc.Controller;

/**
 * The invoker property (IActionInvoker) must be set to use execute().
 */
class Controller extends ControllerBase
{
	private var _invoker : IActionInvoker;
	public var invoker(getInvoker, setInvoker) : IActionInvoker;
	private function getInvoker()
	{
		if (_invoker == null)
			_invoker = new ControllerActionInvoker(ModelBinders.binders);
			
		return _invoker;
	}
	private function setInvoker(i : IActionInvoker)
	{
		_invoker = i;
		return _invoker;
	}
	
	public function new()
	{
		super();
	}
	
	override function executeCore(async : hxevents.Async)
	{
		if(invoker == null)
			throw new Error("No IActionInvoker set on controller '" + Type.getClassName(Type.getClass(this)) + "'");
		
		var action = controllerContext.routeData.get("action");
		
		if(null == action)
			throw new Error("No 'action' data found on route.");
	 //   if(!
		invoker.invokeAction(controllerContext, action, async);
	 //   	_handleUnknownAction(action, async);
	}
}
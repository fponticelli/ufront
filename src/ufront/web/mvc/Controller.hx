package ufront.web.mvc;              
import ufront.web.error.PageNotFoundError;
import ufront.web.HttpContext;
import thx.error.Error;
import ufront.web.routing.RequestContext;
import ufront.web.mvc.Controller;

class Controller extends ControllerBase
{
	public var _invoker : IActionInvoker;
	
	public function new(?invoker : IActionInvoker)
	{
		super();
		
		_invoker = (invoker != null) ? invoker : new ControllerActionInvoker();
	}
	
	override function executeCore()
	{
		var action = controllerContext.routeData.get("action");
		
		if(null == action)
			throw new Error("No 'action' data found on route.");

		if(!_invoker.invokeAction(controllerContext, action))
			_handleUnknownAction(action);
	}
		
	function _handleUnknownAction(action : String)
	{
		var error = "<unknown reason>";
		
		if (Std.is(_invoker, ControllerActionInvoker))
		{
			var i = cast(_invoker, ControllerActionInvoker);
			error = i.error.toString();
		}			
		
		throw new PageNotFoundError().setInner(new Error("action can't be executed because {0}", [error]));
	} 
}
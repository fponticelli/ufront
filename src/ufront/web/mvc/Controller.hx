package ufront.web.mvc;
import ufront.web.mvc.view.IViewHelper;
import ufront.web.error.PageNotFoundError;
import ufront.web.HttpContext;
import udo.error.Error;
import ufront.web.mvc.ControllerContext;
import ufront.web.routing.RequestContext;
import ufront.web.mvc.Controller;

class Controller implements haxe.rtti.Infos
{                               
	static inline var DEFAULT_ACTION = "index";
	var _invoker : MethodInvoker;
	var _defaultAction : String;
	public function new()
	{
		_invoker = new MethodInvoker(); 
		_defaultAction = DEFAULT_ACTION;
	}
	
	public var httpContext(default, null) : HttpContext;
	
	public function execute(requestContext : RequestContext)
	{          
		httpContext = requestContext.httpContext;
		
		var context = new ControllerContext(this, requestContext);
		
		var action = requestContext.routeData.get("action");   
		
		if(null == action)
		{
			requestContext.routeData.data.set("action", action = _defaultAction);
		}

		if(!_invoker.invoke(this, action, context))
			_handleUnknownAction(action);
	} 
	
	public function getViewHelpers() : Array<{ name : Null<String>, helper : IViewHelper }>
	{
		return [];
	}
	
	function _handleUnknownAction(action : String)
	{
		throw new PageNotFoundError().setInner(new Error("action can't be executed because {0}", [_invoker.error.toString()]));
	}
}
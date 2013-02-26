package ufront.web.mvc;
import ufront.web.error.PageNotFoundError;
import ufront.web.HttpContext;
import thx.error.Error;
import ufront.web.routing.RequestContext;
import ufront.web.mvc.Controller;

/**
 * The invoker property (IActionInvoker) must be set to use execute().
 */
class Controller extends ControllerBase implements IActionFilter implements IAuthorizationFilter implements IResultFilter implements IExceptionFilter
{
	private var _invoker : IActionInvoker;
	public var invoker(get, set) : IActionInvoker;
	private function get_invoker()
	{
		if (_invoker == null)
			_invoker = new ControllerActionInvoker(ModelBinders.binders, ControllerBuilder.current, DependencyResolver.current);

		return _invoker;
	}
	private function set_invoker(i : IActionInvoker)
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
		invoker.invokeAction(controllerContext, action, async);
	}

	public function onActionExecuting(filterContext : ActionExecutingContext){}
	public function onActionExecuted(filterContext : ActionExecutedContext){}
	public function onAuthorization(filterContext : AuthorizationContext){}
	public function onException(filterContext : ExceptionContext){}
	public function onResultExecuted(filterContext : ResultExecutedContext){}
	public function onResultExecuting(filterContext : ResultExecutingContext){}
}

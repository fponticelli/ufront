package ufront.web.module;
import ufront.web.routing.UrlRoutingModule;
import ufront.web.routing.RouteCollection;
import thx.error.Error;
import ufront.web.error.InternalServerError;
import ufront.web.error.HttpError;
import ufront.web.routing.EmptyRoute;
import ufront.web.routing.RequestContext;
import ufront.web.routing.RouteData;
import ufront.web.mvc.MvcRouteHandler;
import ufront.web.mvc.Controller;
import ufront.web.HttpApplication;
import ufront.web.IHttpModule;
import haxe.ds.StringMap;
using DynamicsT;
using Strings;
using Types;

class ErrorModule implements IHttpModule
{
	public function new(){

	}
	public function init(application : HttpApplication)
	{
		application.onApplicationError.addAsync(_onError);
	}
	/**
	* TODO: add discrimination about the kind of error
	*/
	public function _onError(e : { application : HttpApplication, error : Error }, async)
	{
		var controller = getErrorController();
		var httpError : HttpError;
		if(Std.is(e.error, HttpError))
		{
			httpError = cast e.error;
		} else {
			httpError = new InternalServerError();
			httpError.setInner(e.error);
		}

		var action = httpError.className().lcfirst();
		if("httpError" == action)
			action = "internalServerError";

		var routeData = new RouteData(
			EmptyRoute.instance, new MvcRouteHandler(),
			{
				action : action,
				error : haxe.Serializer.run(httpError)
			}.toHash());

		var requestContext : RequestContext = null;

		for(module in e.application.modules)
		{
			if(Std.is(module, UrlRoutingModule))
			{
				var umodule : UrlRoutingModule = cast module;
				requestContext = new RequestContext(e.application.httpContext, routeData, umodule.routeCollection);
				break;
			}
		}
		if(null == requestContext)
			requestContext = new RequestContext(e.application.httpContext, routeData, new RouteCollection());

		controller.execute(requestContext, async);
	}

	public function getErrorController() : Controller
	{
		return new ErrorController();
	}

	public function dispose()
	{

	}
}
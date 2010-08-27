package ufront.web.module;            
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
using thx.collections.UHash;    
using thx.text.UString;         
using thx.type.UType;

class ErrorModule implements IHttpModule 
{
	public function new(){
		
	}
	public function init(application : HttpApplication)
	{
		application.onError.add(_onError);
	}                                     
	/**
	* TODO: add discrimination about the kind of error  
	*/
	public function _onError(e : { application : HttpApplication, error : Error })
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
			}.createHash());
		var requestContext = new RequestContext(e.application.httpContext, routeData, e.application.routes);
		
		controller.execute(requestContext);
	}
	     
	public function getErrorController() : Controller
	{
		return new ErrorController();
	}
	
	public function dispose()
	{
		
	}
}
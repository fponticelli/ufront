//RouteName : String
//RouteValue : Hash<String>         

package ufront.web.mvc;
import ufront.web.mvc.view.UrlHelper;
import thx.error.NullArgument;

import ufront.web.mvc.RedirectResult;

class RedirectToControllerResult extends ActionResult
{   
	var controllerName : String;
	var actionName : String;
	var params : Hash<Dynamic>;
	public function new(controllerName : String, actionName = "index", ?params : Hash<Dynamic>)
	{
		this.controllerName = controllerName;
		this.actionName = actionName;
		this.params = null == params ? new Hash() : params;
	} 

	override function executeResult(controllerContext : ControllerContext)
	{
		NullArgument.throwIfNull(controllerContext, "controllerContext");
		
		var url = new UrlHelperInst(controllerContext.requestContext).route(controllerName, actionName, params);       
		var redirect = new RedirectResult(url, false);
		redirect.executeResult(controllerContext);
	}
}
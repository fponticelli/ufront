//RouteName : String
//RouteValue : Hash<String>         

package ufront.web.mvc;
import ufront.web.mvc.view.UrlHelper;
import thx.error.NullArgument;
import ufront.web.mvc.RedirectResult;
using thx.collections.UHash;

class RedirectToControllerResult extends ActionResult
{   
	var params : Hash<Dynamic>;
	public function new(?params : Hash<String>, ?o : Dynamic<String>)
	{
		this.params = null == params ? new Hash() : params;
		if (null != o)
			this.params.importObject(o);
		if (null == this.params.get("action"))
			this.params.set("action", "index");
	} 

	override function executeResult(controllerContext : ControllerContext)
	{
		NullArgument.throwIfNull(controllerContext, "controllerContext");
		
		var url = new UrlHelperInst(controllerContext.requestContext).route(params);       
		var redirect = new RedirectResult(url, false);
		redirect.executeResult(controllerContext);
	}
}
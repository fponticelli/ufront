//RouteName : String
//RouteValue : StringMap<String>

package ufront.web.mvc;
import ufront.web.mvc.view.UrlHelper;
import thx.error.NullArgument;
import ufront.web.mvc.RedirectResult;
import haxe.ds.StringMap;
using Hashes;

class ForwardResult extends ActionResult
{
	var params : StringMap<Dynamic>;
	public function new(?params : StringMap<String>, ?o : Dynamic<String>)
	{
		this.params = null == params ? new StringMap() : params;
		if (null != o)
			this.params.importObject(o);
		if (null == this.params.get("action"))
			this.params.set("action", "index");
	}

	override function executeResult(controllerContext : ControllerContext)
	{
		NullArgument.throwIfNull(controllerContext);

		var url = new UrlHelperInst(controllerContext.requestContext).route(params);
		var redirect = new RedirectResult(url, false);
		redirect.executeResult(controllerContext);
	}
}
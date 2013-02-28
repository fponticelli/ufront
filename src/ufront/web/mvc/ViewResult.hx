package ufront.web.mvc;
import thx.error.NullArgument;
import thx.error.Error;
import ufront.web.mvc.ViewContext;
import haxe.ds.StringMap;
using Types;

/** Represents a class that is used to render a view by using an IView instance that is returned by an IViewEngine object. */
class ViewResult extends ActionResult
{
	/** Gets or sets the view that is rendered to the response */
	public var view : IView;

	/** Gets or sets the view data StringMap object for this result. */
	public var viewData : StringMap<Dynamic>;

	/** Gets or sets the name of the view to render */
	public var viewName : String;

	public function new(?data : StringMap<Dynamic>, ?dataObj : {})
	{
		if (null == data)
			viewData = new StringMap();
		else
			viewData = data;
		if (null != dataObj)
			Hashes.importObject(viewData, dataObj);
	}

	function createContext(result : ViewEngineResult, controllerContext : ControllerContext)
	{
		return new ViewContext(controllerContext, view, result.viewEngine, viewData, controllerContext.controller.getViewHelpers());
	}

	/** When called by the action invoker, renders the view to the response. */
	override function executeResult(context : ControllerContext)
	{
		NullArgument.throwIfNull(context);

		if(null == viewName || "" == viewName)
			viewName = context.routeData.getRequired("action");
		var result = null;
		if(null == view)
		{
			result = findView(context, viewName);
			if(null == result)
				throw new Error("unable to find a view for '{0}'", context.controller.typeName() + "/" + viewName);
            this.view = result.view;
		}
		var viewContext = createContext(result, context);
		var data = new StringMap();
		var r = null;
		try {
			r = view.render(viewContext, data);
		} catch(e : Dynamic) {
			throw new Error("error in the template processing: {0}", Std.string(e));
		}
		writeResponse(context, r, data);
		if(null != result)
			result.viewEngine.releaseView(context, view);
	}

	function writeResponse(context : ControllerContext, content : String, data : StringMap<Dynamic>)
	{
		context.response.write(content);
	}

	function findView(context : ControllerContext, viewName : String) : ViewEngineResult
	{
		NullArgument.throwIfNull(viewName);
		for(engine in ViewEngines.engines)
		{
			var result = engine.findView(context, viewName);
			if(null != result)
				return result;
		}
		return null;
	}
}
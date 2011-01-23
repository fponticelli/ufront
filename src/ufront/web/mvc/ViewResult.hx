package ufront.web.mvc;
import thx.error.NullArgument;
import thx.error.Error;
import ufront.web.mvc.ViewContext;
using thx.type.UType;

class ViewResult extends ActionResult
{   
	public var view : IView;
	public var viewData : Hash<Dynamic>;
//	public var viewEngine :  ViewEngine;
	public var viewName : String;
        
	public function new(?data : Hash<Dynamic>)
	{
		viewData = null == data ? new Hash() : data;
	}
	
	function createContext(result : ViewEngineResult, controllerContext : ControllerContext)
	{
		return new ViewContext(controllerContext, view, result.viewEngine, viewData, controllerContext.controller.getViewHelpers());
	}
	
	override function executeResult(context : ControllerContext)
	{
		NullArgument.throwIfNull(context, "context");
		                                   
		if(null == viewName || "" == viewName)
			viewName = context.routeData.getRequired("action");   		   
		var result = null;      
		if(null == view) 
		{          
			result = findView(context, viewName);
			if(null == result)
				throw new Error("unable to find a view/engine for '{0}'", context.controller.typeName() + "/" + viewName);   
            this.view = result.view;
		}   
		var viewContext = createContext(result, context);
		var data = new Hash();
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
	
	function writeResponse(context : ControllerContext, content : String, data : Hash<Dynamic>)
	{
		context.response.write(content);
	}
	
//	function findEngine() : ViewEngine
//	{
//		return throw new NotImplemented();
//	}                  
	
	function findView(context : ControllerContext, viewName : String) : ViewEngineResult
	{         
		NullArgument.throwIfNull(viewName, "viewName");
		for(engine in ViewEngines.engines)
		{
			var result = engine.findView(context, viewName);
			if(null != result)
				return result;
		}
		return null;
	}
}
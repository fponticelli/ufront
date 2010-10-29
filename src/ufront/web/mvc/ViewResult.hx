package ufront.web.mvc;
import thx.error.NullArgument;
import thx.error.Error;
import ufront.web.mvc.ViewContext;
import thx.error.NullArgument;

class ViewResult extends ActionResult
{   
	public var view : IView;
	public var viewData : Hash<Dynamic>;
//	public var viewEngine :  ViewEngine;
	public var viewName : String;
	public var viewTempData : Hash<Dynamic>;
        
	public function new(?data : Hash<Dynamic>, ?tempData : Hash<Dynamic>)
	{
		viewData = null == data ? new Hash() : data;
		viewTempData = null == tempData ? new Hash() : tempData;
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
            this.view = result.view;
		}   
		var viewContext = createContext(result, context);
		
		var r = null;
		try {
			r = view.render(viewContext);
		} catch(e : Dynamic) {
			throw new Error("error in the template processing: {0}", Std.string(e));
		}
		
		context.response.write(r); 
		if(null != result)
			result.viewEngine.releaseView(context, view);
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
		throw new Error("unable to find a view/engine for {0}", viewName);
	}
}
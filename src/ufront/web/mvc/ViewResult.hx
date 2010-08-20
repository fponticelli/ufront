package ufront.web.mvc;
import udo.error.NullArgument;
import udo.error.Error;
import ufront.web.mvc.ViewContext;
import udo.error.NullArgument;

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
		var viewContext = new ViewContext(context, view, result.viewEngine, viewData);   
		
		context.response.write(view.render(viewContext));
		
		if(null != result)
			result.viewEngine.releaseView(context, view);
	}
	
//	function findEngine() : ViewEngine
//	{
//		return throw "not implemented";
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
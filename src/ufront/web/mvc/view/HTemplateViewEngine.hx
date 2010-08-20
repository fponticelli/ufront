package ufront.web.mvc.view;
import udo.neutral.io.File;
import htemplate.Template;
using udo.collections.UArray;
using udo.type.UType;    
using udo.text.UString;
import ufront.web.mvc.IView;
import ufront.web.mvc.ViewEngineResult;
import ufront.web.mvc.ControllerContext;
import ufront.web.mvc.IViewEngine;    
import udo.neutral.FileSystem;                                              

class HTemplateViewEngine implements IViewEngine 
{   
	public static var DEFAULT_EXTENSION = ".html";
	public function new()
	{
		
	}
                                
	public function getTemplatesDirectory(controllerContext : ControllerContext)
	{
		return controllerContext.request.scriptDirectory + "view/";
	}

	public function findView(controllerContext : ControllerContext, viewName : String) : ViewEngineResult
	{   
		var parts = controllerContext.controller.fullName().split(".");
		
		parts
			.removeR("controller")
			.removeR("controllers");
		
		parts[parts.length-1] = parts[parts.length-1].lcfirst();
		
		var controllerPath =  parts.join("/");                                          
		
		var template = getTemplate(controllerContext, controllerPath + "/" + viewName);
		if(null == template)   
		{
			template = getTemplate(controllerContext, viewName);
			if(null == template)
		    	return null;
		}
		return new ViewEngineResult(new HTemplateView(template), this);
	}       
	
	function _templatePath(controllerContext : ControllerContext, path : String)
	{
		return getTemplatesDirectory(controllerContext) + path + DEFAULT_EXTENSION;
	}
	
	public function getTemplate(controllerContext : ControllerContext, path : String) 
	{            
	   	var fullpath = _templatePath(controllerContext, path);
		if(!FileSystem.exists(fullpath))
			return null;   
		else
			return new Template(File.getContent(fullpath));
	}   
	
	
	public function releaseView(controllerContext : ControllerContext, view : IView) : Void;
}
package ufront.web.mvc.view;
import thx.error.NotImplemented;
import thx.sys.io.File;
import erazor.Template;
using Arrays;
using Types;
using Strings;
using StringTools;
import ufront.web.mvc.IView;
import ufront.web.mvc.ViewEngineResult;
import ufront.web.mvc.ControllerContext;
import ufront.web.mvc.IViewEngine;
import thx.sys.FileSystem;

/** Represents a view engine that is used to render a web page that uses the erazor syntax. */
class ErazorViewEngine implements ITemplateViewEngine<Template>
{
	public static var DEFAULT_EXTENSION = ".html";
	public function new(){}

	public function getTemplatesDirectory(controllerContext : ControllerContext)
	{
		return controllerContext.request.scriptDirectory + "view/";
	}

	/** Finds the specified view by using the specified controller context and master view name. */
	public function findView(controllerContext : ControllerContext, viewName : String) : ViewEngineResult
	{
		var template = getTemplate(controllerContext, viewName);
		if(null == template)
		   	return null;
		return new ViewEngineResult(new ErazorView(template), this);
	}

	function _templatePath(controllerContext : ControllerContext, path : String)
	{
		return getTemplatesDirectory(controllerContext) + path + DEFAULT_EXTENSION;
	}

	/**
	 *  @todo find a sync function in node.js for file exists
	 */
	public function getTemplate(controllerContext : ControllerContext, path : String) : Template
	{
		if (!path.startsWith("/"))
		{
			var parts = controllerContext.controller.fullName().split(".");
			parts
				.delete("controller")
				.delete("controllers");

			parts[parts.length-1] = parts[parts.length-1].lcfirst();
			var controllerPath =  parts.join("/");
			if(controllerPath.substr(-10).toLowerCase() == "controller")
				controllerPath = controllerPath.substr(0, -10);
			path = controllerPath + "/" + path;
		} else {
			path = path.substr(1);
		}

	   	var fullpath = _templatePath(controllerContext, path);
#if (neko || php)
		if(!FileSystem.exists(fullpath))
			return null;
		else
			return new Template(File.getContent(fullpath));
#elseif nodejs
		try {
			return new Template(js.Node.fs.readFileSync(fullpath));
		} catch(e : Dynamic) {
			return null;
		}
#else
    	return throw new NotImplemented();
#end
	}

	/** Releases the specified view by using the specified controller context. */
	public function releaseView(controllerContext : ControllerContext, view : IView) : Void{}
}
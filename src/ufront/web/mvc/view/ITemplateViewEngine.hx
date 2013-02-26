package ufront.web.mvc.view;
import ufront.web.mvc.IViewEngine;
import haxe.ds.StringMap;

/**
 * ...
 * @author Franco Ponticelli
 */

interface ITemplateViewEngine<Template> extends IViewEngine
{
	public function getTemplate(controllerContext : ControllerContext, path : String) : Template;
}
/*
typedef TemplateDef = {
	public function execute(vars : StringMap<Dynamic>) : String;
}
*/
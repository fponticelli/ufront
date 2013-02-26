package ufront.web.mvc.view;
import ufront.web.mvc.IViewEngine;

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
	public function execute(vars : Hash<Dynamic>) : String;
}
*/
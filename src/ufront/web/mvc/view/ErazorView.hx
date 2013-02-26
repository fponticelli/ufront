package ufront.web.mvc.view;

import erazor.Template;
import haxe.ds.StringMap;

class ErazorView extends TemplateView<erazor.Template>
{
	override public function executeTemplate(template : Template, data : StringMap<Dynamic>) : String
	{
		return template.execute(data);
	}

	override public function data()
	{
		return template.variables;
	}
}
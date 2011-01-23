package ufront.web.mvc.view;     

import erazor.Template;

class ErazorView extends TemplateView<erazor.Template>
{
	override public function executeTemplate(template : Template, data : Hash<Dynamic>) : String
	{
		return template.execute(data);
	}
	
	override public function data()
	{
		return template.variables;
	}
}
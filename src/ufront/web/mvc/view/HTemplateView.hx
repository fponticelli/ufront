package ufront.web.mvc.view;

#if htemplate
import htemplate.Template;

class HTemplateView extends TemplateView<htemplate.Template>
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
#end
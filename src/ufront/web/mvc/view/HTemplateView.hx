package ufront.web.mvc.view;

#if htemplate
import htemplate.Template;
import haxe.ds.StringMap;

class HTemplateView extends TemplateView<htemplate.Template>
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
#end
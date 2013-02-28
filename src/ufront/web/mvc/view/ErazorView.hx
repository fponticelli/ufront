package ufront.web.mvc.view;

import erazor.Template;
import haxe.ds.StringMap;

/** Represents the class used to create views that have Erazor syntax. */
class ErazorView extends TemplateView<erazor.Template>
{
	/** Execute the given template by passing in a StringMap with the data to insert */
	override public function executeTemplate(template : Template, data : StringMap<Dynamic>) : String
	{
		return template.execute(data);
	}

	override public function data()
	{
		return template.variables;
	}
}
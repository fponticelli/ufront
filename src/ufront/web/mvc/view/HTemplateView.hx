package ufront.web.mvc.view;     

import ufront.web.mvc.ViewContext;
import ufront.web.mvc.IView;                     
import htemplate.Template;

class HTemplateView implements IView 
{         
	public var template(default, null) : Template;
	public function new(template : Template)
	{
		this.template = template;
	}                           

	public function render(viewContext : ViewContext)
	{             
		return template.execute(viewContext.viewData);
	}
}
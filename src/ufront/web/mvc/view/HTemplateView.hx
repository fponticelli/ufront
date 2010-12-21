package ufront.web.mvc.view;     
import ufront.web.mvc.view.HtmlHelper;
import ufront.web.mvc.view.XHtmlHelper;
import thx.collections.HashList;

import ufront.web.mvc.ViewContext;
import ufront.web.mvc.IView;                     
import htemplate.Template;

class HTemplateView implements IView 
{         
	public var template(default, null) : Template; 
	public var wrappers(default, null) : HashList<Template>;
	public var templateVars(default, null) : Hash<Dynamic>;
	public function new(template : Template)
	{
		this.template = template;    
		this.wrappers = new HashList();                  
		this.templateVars = new Hash(); 
	}                           

	public function render(viewContext : ViewContext)
	{          
		var data = new HTemplateData(viewContext, this);
		data.register();                     	
		_registerAutomaticHelpers(viewContext, data);   	
		for(info in viewContext.viewHelpers)     
			data.registerHelper(info.name, info.helper); 	 	
		var result = template.execute(templateVars);   
		for(key in wrappers.keys())
		{           
			viewContext.viewData.set(key, result);
			result =  wrappers.get(key).execute(templateVars);
		}      
		return result;
	}  
	
	private function _registerAutomaticHelpers(viewContext : ViewContext, data : HTemplateData)
	{            
		var urlHelper = new UrlHelper(viewContext.requestContext);
		data.registerHelper("url", urlHelper);
		switch(viewContext.response.contentType)
		{           
			case "application/xhtml+xml":
				data.registerHelper("html", new XHtmlHelper(viewContext, data, urlHelper)); 
			case "text/html":
				data.registerHelper("html", new HtmlHelper(viewContext, data, urlHelper));
		}
	}
}
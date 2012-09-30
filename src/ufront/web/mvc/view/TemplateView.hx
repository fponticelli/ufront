package ufront.web.mvc.view;

import thx.error.Error;
import ufront.web.mvc.view.HtmlHelper;
import ufront.web.mvc.view.XHtmlHelper;
import thx.collection.HashList;

import ufront.web.mvc.ViewContext;
import ufront.web.mvc.IView;

/**
 * ...
 * @author Franco Ponticelli
 */

class TemplateView<Template> implements ITemplateView<Template>
{
	public var template(default, null) : Template;
	public var wrappers(default, null) : HashList<Template>;
	public function new(template : Template)
	{
		this.template = template;
		this.wrappers = new HashList();
	}

	// TODO: the helpers here should be moved to a filter
	public function render(viewContext : ViewContext, outputData : Hash<Dynamic>)
	{
		var helpers = viewContext.viewHelpers.copy();

#if uform
		helpers.push(new UFormHelper());
#end

		var urlHelper = new UrlHelper(viewContext.requestContext);
		helpers.push(urlHelper);
		helpers.push(new TemplateHelper(viewContext, this));
		helpers.push(new FormatHelper());
		switch(viewContext.response.contentType)
		{
			case "application/xhtml+xml":
				helpers.push(new XHtmlHelper(urlHelper.inst));
			case "text/html":
				helpers.push(new HtmlHelper(urlHelper.inst));
		}
		
		//integration with Autoform.
		//will be uncommented after autoform 2
		//release (or inclusion on ufront)
		// helpers.push(new FormHelper());

		for (helper in helpers)
			helper.register(viewContext.viewData);
		var result = executeTemplate(template, viewContext.viewData);
		var hash = data();
		for(key in wrappers.keys())
		{
			hash.set(key, result);
			var wrapper = wrappers.get(key);
			result = executeTemplate(wrapper, hash);
		}

		for (key in hash.keys())
			outputData.set(key, hash.get(key));
		return result;
	}

	public function data() : Hash<Dynamic>
	{
		return throw new Error("abstract method");
	}

	public function executeTemplate(template : Template, data : Hash<Dynamic>) : String
	{
		return throw new Error("abstract method");
	}
}
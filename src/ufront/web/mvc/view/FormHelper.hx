// package ufront.web.mvc.view;
// import ufront.web.mvc.ViewContext;
// using StringTools;
// import autoform.AutoForm;
// import autoform.renderer.HtmlDocument;
// using autoform.renderer.HtmlDocument;
// using autoform.renderer.HtmlTag;
// using autoform.domrenderer.DomRenderingEngine;
// using autoform.bootstraprenderer.BootstrapRenderingEngine;

// class FormHelper implements ufront.web.mvc.IViewHelper
// {
// 	public var name(default, null) : String;
	
// 	public function new(name = "Form")
// 	{
// 		this.name = name;
		
// 	}

// 	public function register(data : Hash<Dynamic>)
// 	{
// 		data.set(name, new FormHelperInst());
// 	}
// }

// class FormHelperInst
// {
	
// 	public function new()
// 	{
		
// 	}

// 	public function domRender(form:AutoForm,action:String)
// 	{
// 		var document=HtmlDocument.create();
//         var html=document.html();
//         new DomRenderingEngine(html,action).with(form).render();
//         return html;
// 	}
// 	public function bootstrapRender(form:AutoForm,action:String,defaultSubmit:String)
// 	{
// 		var document=HtmlDocument.create();
//         var html=document.html();
//         new BootstrapRenderingEngine(html,action,defaultSubmit).with(form).render();
//         return html;
// 	}

// }
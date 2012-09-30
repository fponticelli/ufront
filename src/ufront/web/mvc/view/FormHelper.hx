		//integration with Autoform.
		//will be uncommented after autoform 2
		//release (or inclusion on ufront)

// package ufront.web.mvc.view;
// import ufront.web.mvc.ViewContext;
// using StringTools;
// import autoform.AutoForm;
// import autoform.renderer.HtmlDocument;
// using autoform.renderer.HtmlDocument;
// using autoform.renderer.HtmlTag;
// using autoform.domrenderer.DomRenderingEngine;
// using autoform.bootstraprenderer.BootstrapRenderingEngine;
// /********************************************************************************
//  *
//  *	This helper allow easy rendering of autoform forms.trace
//  *	
//  *	Controllers has to return an AutoForm instance to view, that
//  *  could be rendered using either domRender method for standard 
//  *  HTML renddering, or bootstrapRender for <a href="http://twitter.github.com/bootstrap/" >Twitter bootstrap</a>
//  *	rendering.
//  *	
// **********************************************************************************/
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


// /********************************************************************************
//  *
//  *	This class is the implementation of FormHelper helper.trace
//  *  See FormHelper documentation for details.
//  *	
// **********************************************************************************/
// class FormHelperInst
// {
	
// 	public function new()
// 	{
		
// 	}

// 	/********************************************************************************
// 	 *
// 	 *	Allow to render a form to standard HTML
// 	 *	@Param form 	The form to render
// 	 *  @Param action	The value of the action attribute of rendered form
// 	 *	
// 	**********************************************************************************/
// 	public function domRender(form:AutoForm,action:String)
// 	{
// 		//TODO: add a default submit parameter as bootstrapRender
// 		var document=HtmlDocument.create();
//         var html=document.html();
//         new DomRenderingEngine(html,action).with(form).render();
//         return html;
// 	}

// 	/********************************************************************************
// 	 *
// 	 *	Allow to render a form to <a href="http://twitter.github.com/bootstrap/" >Twitter bootstrap</a> 
// 	 *	based HTML.
// 	 *	@Param form 			The form to render
// 	 *  @Param action			The value of the action attribute of rendered form
// 	 *  @Param defaultSubmit	HTML representing one or more submit tag to add to end of form
// 	 *	
// 	**********************************************************************************/
// 	public function bootstrapRender(form:AutoForm,action:String,defaultSubmit:String)
// 	{
// 		var document=HtmlDocument.create();
//         var html=document.html();
//         new BootstrapRenderingEngine(html,action,defaultSubmit).with(form).render();
//         return html;
// 	}

// }
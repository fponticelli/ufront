package ufront.web.mvc.view;
import udo.error.Error;
import ufront.web.mvc.view.HTemplateViewEngine;
import ufront.web.mvc.ViewContext;
import htemplate.Template;                            

class HTemplateData 
{       
	var data : Hash<Dynamic>;   
	var context : ViewContext;    
	var template : HTemplateView;
	public function new(context : ViewContext, template : HTemplateView)
	{
		this.context = context;
		this.data = context.viewData;
		this.template = template;
	}      
	
	public function get(key : String, ?alt : Dynamic)
	{                                               
		if(null == alt)
			alt = "";
		return data.exists(key) ? data.get(key) : alt;
	}  
	
	public function has(value : Dynamic, key : String)
	{
		return Reflect.hasField(value, key);
	} 
	        
	public function notempty(key : String)
	{
		var v = data.get(key);  
		if(v == null || v == "")
			return false;
		else if(Std.is(v, Array))
			return v.length > 0;
		else if(Std.is(v, Bool))
			return v;
		else
			return true;
	}
	
	public function push(varname : String, element : Dynamic)
	{
		var arr = data.get(varname);
		if(null == arr)
		{
			arr = [];
			data.set(varname, arr);
		}
		arr.push(element);
	} 
	
	public function unshift(varname : String, element : Dynamic)
	{
		var arr = data.get(varname);
		if(null == arr)
		{
			arr = [];
			data.set(varname, arr);
		}
		arr.unshift(element);
	}
	
	public function wrap(templatepath : String, ?contentvar : String)
	{
		if(null == contentvar)   
			contentvar = "content";   
		
		var engine : HTemplateViewEngine = cast context.viewEngine;
			
		var t = engine.getTemplate(context.controllerContext, templatepath);
		if(null == t)
			throw new Error("the wrap template '{0}' does not exist", templatepath);
			
		template.wrappers.set(contentvar, t);
		return "";
	}    
	
	public function include(templatepath : String)
	{
		var engine : HTemplateViewEngine = cast context.viewEngine;
			
		var t = engine.getTemplate(context.controllerContext, templatepath);
		if(null == t)
			throw new Error("the include template '{0}' does not exist", templatepath);
		
		return t.execute(template.templateVars);
	}                                           
	
	// slot() // should call a controller action and embed its ViewResult
	
	public function register()
	{           
		var h = template.templateVars;
		h.set("get",      get);
		h.set("set",      data.set);
		h.set("exists",   data.exists); 
		h.set("has",      has); 
		h.set("include",  include);
		h.set("notempty", notempty);
		h.set("push",     push); 
		h.set("unshift",  unshift); 
		h.set("wrap",     wrap);
	}   
	
	public function registerHelper(name : String, helperInstance : IViewHelper)
	{           
		var h = template.templateVars;
		var carrier : Dynamic;
		if(null == name || "" == name) 
		{ 
		    for(field in helperInstance.getHelperFieldNames()) 
				h.set(field, Reflect.field(helperInstance, field));
		} else {  
			if(h.exists(name))
				return;
			var carrier = {};
			h.set(name, carrier); 
			for(field in helperInstance.getHelperFieldNames())   
				Reflect.setField(carrier, field, Reflect.field(helperInstance, field));
		}
	}
}
package ufront.web.mvc.view;
import thx.error.NullArgument;
import thx.error.Error;
import ufront.web.mvc.ViewContext;

class TemplateHelper<Template> implements ufront.web.mvc.IViewHelper
{       
	var context : ViewContext;    
	var template : ITemplateView<Template>;
	public function new(context : ViewContext, template : ITemplateView<Template>)
	{
		this.context = context;
		this.template = template;
	}      
	
	public function get(key : String, ?alt : Dynamic)
	{                                               
		if(null == alt)
			alt = "";
		var hash = template.data();
		return hash.exists(key) ? hash.get(key) : alt;
	}
	
	public function exists(key : String) 
	{
		return template.data().exists(key);
	}                           

	public function set(key : String, value : Dynamic) 
	{
		template.data().set(key, value);
	}

	public function has(value : Dynamic, key : String)
	{
		return Reflect.hasField(value, key);
	} 
	        
	public function notempty(key : String) : Bool
	{
		var v = template.data().get(key);  
		if(v == null || v == "")
			return false;
		else if(Std.is(v, Array))
			return v.length > 0;
		else if(Std.is(v, Bool))
			return cast v;
		else
			return true;
	}
	
	public function push(varname : String, element : Dynamic)
	{
		var hash = template.data();
		var arr = hash.get(varname);
		if(null == arr)
		{
			arr = [];
			hash.set(varname, arr);
		}
		arr.push(element);
	} 
	
	public function unshift(varname : String, element : Dynamic)
	{
		var hash = template.data();
		var arr = hash.get(varname);
		if(null == arr)
		{
			arr = [];
			hash.set(varname, arr);
		}
		arr.unshift(element);
	}
	
	public function wrap(templatepath : String, ?contentvar : String)
	{
		if(null == contentvar)   
			contentvar = "layoutContent";   
		
		var engine : ITemplateViewEngine<Template> = cast context.viewEngine;
			
		var t = engine.getTemplate(context.controllerContext, templatepath);
		if(null == t)
			throw new Error("the wrap template '{0}' does not exist", templatepath);
			
		template.wrappers.set(contentvar, t);
		return "";
	}    
	
	public function include(templatepath : String)
	{
		var engine : ITemplateViewEngine<Template> = cast context.viewEngine;
			
		var t = engine.getTemplate(context.controllerContext, templatepath);
		if(null == t)
			throw new Error("the include template '{0}' does not exist", templatepath);
		return template.executeTemplate(t, template.data());
	}
	
	public function register(data : Hash<Dynamic>)
	{
		data.set("get",      get);
		data.set("set",      set);
		data.set("exists",   exists); 
		data.set("has",      has); 
		data.set("include",  include);
		data.set("notempty", notempty);
		data.set("push",     push); 
		data.set("unshift",  unshift); 
		data.set("wrap",     wrap);   
	}
}
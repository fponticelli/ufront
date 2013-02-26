package ufront.web.mvc.view;
import thx.collection.Set;
import thx.error.NullArgument;
import thx.error.Error;
import ufront.web.mvc.ViewContext;
import haxe.ds.StringMap;
using Hashes;

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

	public function routeData()
	{
		return context.routeData.data.toDynamic();
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

	public function include(templatepath : String, ?data : Dynamic)
	{
		var engine : ITemplateViewEngine<Template> = cast context.viewEngine;

		var t = engine.getTemplate(context.controllerContext, templatepath);
		if(null == t)
			throw new Error("the include template '{0}' does not exist", templatepath);
		var variables = template.data();
		var restore = if (null != data)
		{
			var old = new StringMap<Dynamic>();
			var toremove = new Set();

			var fields = Reflect.fields(data);
			for (field in fields)
			{
				var value = variables.get(field);
				if (null != value)
					old.set(field, value);
				else
					toremove.add(field);
				variables.set(field, Reflect.field(data, field));
			}

			function() {
				for (key in toremove)
					variables.remove(key);
				for (key in old.keys())
					variables.set(key, old.get(key));
			};
		} else {
			function() { };
		}

		var result = template.executeTemplate(t, variables);
		restore();
		return result;
	}

	public function merge<T>(dst : Dynamic<T>, ?src : Dynamic<T>) : Dynamic<T>
	{
		if (null == src)
			src = cast routeData();
		for (key in Reflect.fields(src))
			if (!Reflect.hasField(dst, key))
				Reflect.setField(dst, key, Reflect.field(src, key));
		return dst;
	}

	public function register(data : StringMap<Dynamic>)
	{
		data.set("get",			get);
		data.set("set",			set);
		data.set("exists",		exists);
		data.set("has",			has);
		data.set("include",		include);
		data.set("notempty",	notempty);
		data.set("push",		push);
		data.set("unshift",		unshift);
		data.set("wrap",		wrap);
		data.set("routeData",	routeData);
		data.set("merge",		merge);
		data.set("now",			Date.now());
	}
}
package ufront.web.mvc.view;
import ufront.web.mvc.ViewContext;
using StringTools;
import ufront.web.mvc.view.UrlHelper;

class HtmlHelper implements ufront.web.mvc.IViewHelper
{
	public var name(default, null) : String;
	public var urlHelper(default, null) : UrlHelperInst;
	public function new(name = "Html", urlHelper : UrlHelperInst)
	{
		this.name = name;
		this.urlHelper = urlHelper;
	}

	public function register(data : Hash<Dynamic>)
	{
		data.set(name, new HtmlHelperInst(urlHelper));
	}
}

class HtmlHelperInst
{
	var __url : UrlHelperInst;
	public function new(urlHelper : UrlHelperInst)
	{
		__url = urlHelper;
	}

	public function encode(s : String)
	{
		return StringTools.htmlEscape(s);
	}

	/*
	  TODO:
		* form (with action/controller derivatives)
		* checkbox
		* tag
		* open
		* uform related?
		* dropdown
		* editor?
		* hidden
		* label
		* listbox
		* password
		* radiobutton
		* textarea
		* textbox
		* validation markup?
		* close
	*/

	// TODO: review
	// Andrea.Parodi@ebansoftware.net - added apos escape to avoid HTML injection in attribute
	public function attributeEncode(s : String)
	{
		//allow to encode null attributes without check for null on client code
		if (s==null)
			return "";
		return s.replace('&', '&amp;').replace('<', '&lt;').replace("'", '&apos;').replace('"', '&quote;');
	}

	public function link(text : String, url : String, ?attrs : Dynamic)
	{
		if(null == attrs)
			attrs = {};
		attrs.href = url;
	   	return open("a", attrs) + text + close("a");
	}

	public function route(text : String, ?data : Dynamic, ?attrs : Dynamic)
	{
		return link(text, __url.route(data), attrs);
	}

	public function linkif(test : String, text : String, url : String, ?attrs : Dynamic)
	{
		if(null == attrs)
			attrs = {};
		if(null == test)
		    test = __url.current();
		if(url == test)
		{
			return open("span", attrs) + text + close("span");
		} else {
			attrs.href = url;
	   		return open("a", attrs) + text + close("a");
   		}
	}

	public function routeif(test : String, text : String, ?data : Dynamic, ?attrs : Dynamic)
	{
		return linkif(test, text, __url.route(data), attrs);
	}

	public function open(name : String, attrs : Dynamic)
	{
		return "<" + name + _attrs(attrs) + ">";
	}

	public function close(name : String)
	{
		return "</" + name + ">";
	}

	public function tag(name : String, attrs : Dynamic)
	{
		return "<" + name + _attrs(attrs) + ">";
	}

	function _attrs(attrs : Dynamic)
	{
		var arr = [];

		for(name in Reflect.fields(attrs))
		{
			var value = Reflect.field(attrs, name);
			if(value == name)
				arr.push(name)
			else
				arr.push(name + '=' + _qatt(Reflect.field(attrs, name)));
		}

		if(arr.length == 0)
			return "";
		else
			return " " + arr.join(" ");
	}

	static var WS_PATTERN = ~/\s/m;

	function _qatt(value : String)
	{
		if(WS_PATTERN.match(value))
			return '"' + attributeEncode(value) + '"';
		else
			return attributeEncode(value);
	}
}
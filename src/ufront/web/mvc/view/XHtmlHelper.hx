package ufront.web.mvc.view;

import ufront.web.mvc.view.HtmlHelper;

class XHtmlHelper extends HtmlHelper
{
	override public function register(data : Hash<Dynamic>)
	{
		data.set(name, new XHtmlHelperInst(urlHelper));
	}
}

class XHtmlHelperInst extends HtmlHelperInst
{
	override function open(name : String, attrs : Dynamic)
	{
		return "<" + name + _attrs(attrs) + ">";
	}

	override function close(name : String)
	{
		return "</" + name + ">";
	}

	override function tag(name : String, attrs : Dynamic)
	{
		return "<" + name + _attrs(attrs) + "/>";
	}

	override function _attrs(attrs : Dynamic)
	{
		var arr = [];

		for(name in Reflect.fields(attrs))
		{
			arr.push(name + '=' + _qatt(Reflect.field(attrs, name)));
		}

		if(arr.length == 0)
			return "";
		else
			return " " + arr.join(" ");
	}

	override function _qatt(value : String)
	{
		return '"' + attributeEncode(value) + '"';
	}
}
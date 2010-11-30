package ufront.web.mvc;     
import thx.html.HtmlFormat;
import thx.html.XHtmlFormat;
import thx.html.HtmlParser;
using StringTools;

// add script
// add css
// add meta
// add head link
// add IE only scripts
// add IE only css
// html tag should not increment level
// DOCTYPE should be lowercase
// remove extra Newlines
// add favicon
// fix doctype parsing for XHtml 
// add chrome compatibility

// add agent specific things:
//	- IE only tags
//	- viewport <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;">
//	- equivalences: <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
//					<meta charset="utf-8">

class HtmlViewResult extends ViewResult
{
	public var version : HtmlVersion;
	public var charset(getCharset, setCharset) : String;
	public var language(getLanguage, setLanguage) : String;
	public var autoformat : Bool;
	public var title(getTitle, setTitle) : String;
	
	public function new(?data : Hash<Dynamic>, ?version : HtmlVersion, language = "en", charset = "UTF-8")
	{
		super(data);
		this.version = null == version ? Html5 : version;
		this.language = language;
		this.charset = charset;
		this.autoformat = true;
	}
		
	override function writeResponse(context : ControllerContext, content : String)
	{ 
		var template = getTemplate(version);
		var result : String = null;
		if(autoformat)
		{
			var dom = Html.toXml(template.replace("{content}", content));
			handleDom(dom, context);
			result = getFormatter(version).format(dom);
		} else {
			var dom = Html.toXml(template);
			handleDom(dom, context);
			result = getFormatter(version).format(dom);
			result = result.replace("{content}", content);
		}
		context.response.write(result);
	}
	
	function handleDom(dom : Xml, context : ControllerContext)
	{       
		var html  = dom.firstElement();
		var head  = html.firstElement();
		var body  = head.elementsNamed("body").next();
		var title = head.elementsNamed("title").next();  
		
		// title
		var t = getTitle();
		if(null != t)
			title.addChild(Xml.createPCData(t));
		
		// language
		var l = getLanguage();
		if(null != l)
		{
			html.set("lang", l);
			switch(version)
			{
				case XHtml10Transitional, XHtml10Frameset, XHtml10Strict, XHtml11: 
					html.set("xml:lang", l);
				default:
				//
			}
		}
		
		// encoding
		var c = getCharset();
		if(null != c)
		{
		 	switch(version)
			{
				case Html401Strict, Html401Transitional, Html401Frameset, XHtml10Transitional, XHtml10Frameset, XHtml10Strict, XHtml11:
                	var meta = Xml.createElement("meta");
					meta.set("http-equiv", "content-type");
 					meta.set("content", "text/html; charset=" + c);
					head.insertChild(meta, 0);
				case Html5:
					var meta = Xml.createElement("meta");
					meta.set("charset", c);
					head.insertChild(meta, 0);
			}   
		}
	} 
	
	function setTitle(v) return title = v
	function getTitle()
	{
		if(null != title)
			return title;
		else
			return viewData.get("title");
	}
	
	function setLanguage(v) return language = v
	function getLanguage()
	{
		if(null != language)
			return language;
		else if(viewData.exists("language"))
			return viewData.get("language");
		else
			return viewData.get("lang");
	}
	
	function setCharset(v) return charset = v
	function getCharset()
	{
		if(null != charset)
			return charset;
		else
			return viewData.get("charset");
	}
	
	static function getFormatter(version) : XHtmlFormat
	{
		var format : XHtmlFormat;
		switch(version)
		{
			case Html401Strict, Html401Transitional, Html401Frameset:
				var f = new HtmlFormat();
				f.quotesRemoval = false;
				f.useCloseSelf = false;
				format = f;
			case Html5:
				var f = new HtmlFormat();
				f.quotesRemoval = true;
				f.useCloseSelf = true;
				format = f;
			case XHtml10Transitional, XHtml10Frameset, XHtml10Strict, XHtml11:
				format = new XHtmlFormat();
		}
		format.autoformat = true;
		format.normalizeNewlines = true;
		return format;
	}
	
	static function getTemplate(version)
	{
		switch(version)
		{
			case Html401Strict:
				return getTemplateHtml4Strict();
			case Html401Transitional:
				return getTemplateHtml4Transitional();
			case Html401Frameset:
				return getTemplateHtml4Frameset();
			case Html5:
				return getTemplateHtml5();
			case XHtml10Transitional:
				return getTemplateXHtml10Transitional();
			case XHtml10Frameset:
				return getTemplateXHtml10Frameset();
			case XHtml10Strict:
				return getTemplateXHtml10Strict();
			case XHtml11:
				return getTemplateXHtml11();
		}   
	}
	
	static function getTemplateHtml4Strict()
	{
		return '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN""http://www.w3.org/TR/html4/strict.dtd"><html><head><title></title></head><body>{content}</body></html>';
	}
	
	static function getTemplateHtml4Transitional()
	{
		return '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN""http://www.w3.org/TR/html4/loose.dtd"><html><head><title></title></head><body>{content}</body></html>';
	}
	
	static function getTemplateHtml4Frameset()
	{
		return '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd"><html><head><title></title></head><frameset><noframes><body>{content}</body></noframes></frameset></html>';
	}
	
	static function getTemplateHtml5()
	{
		return '<!doctype html><html><head><title></title></head><body>{content}</body></html>';
	}
	
	static function getTemplateXHtml10Transitional()
	{
		return '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><title></title></head><body>{content}</body></html>';
	}
	
	static function getTemplateXHtml10Strict()
	{
		return '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><title></title></head><body>{content}</body></html>';
	}
	
	static function getTemplateXHtml10Frameset()
	{
		return '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><title></title></head><frameset><noframes><body>{content}</body></noframes></frameset></html>';
	}
	
	static function getTemplateXHtml11()
	{
		return //'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">'
		'<html xmlns="http://www.w3.org/1999/xhtml"><head><title></title></head><body>{content}</body></html>';
	}
}

enum HtmlVersion
{
	Html401Strict;
	Html401Transitional;
	Html401Frameset;
	Html5;
	XHtml10Transitional;
	XHtml10Strict;
	XHtml10Frameset;
	XHtml11;
}
package ufront.web.mvc.view;
import ufront.web.mvc.view.HTemplateData;
import ufront.web.mvc.ViewContext;    
using StringTools;

class HtmlHelper implements IViewHelper
{       
	public var viewContext(default, null) : ViewContext;
	public var templateData(default, null) : HTemplateData;  
	public var urlHelper(default, null) : UrlHelper; 
	public function new(viewContext : ViewContext, templateData : HTemplateData, urlHelper : UrlHelper)
	{
		this.viewContext = viewContext;   
		this.templateData = templateData;     
		this.urlHelper = urlHelper;                             
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
	public function attributeEncode(s : String)
	{
		return s.replace('"', '&quot;').replace('&', '&amp;').replace('<', '&lt;');
	}
	
	public function link(text : String, url : String, ?attrs : Dynamic)
	{
		if(null == attrs)
			attrs = {};
		attrs.href = url;
	   	return open("a", attrs) + text + close("a");
	}   
	
	public function action(text : String, name : String, ?data : Dynamic, ?attrs : Dynamic)
	{           
		return link(text, urlHelper.action(name, data), attrs);
	}
	
	public function controller(text : String, controllerName : String, ?action : String, ?data : Dynamic, ?attrs : Dynamic)
	{           
		return link(text, urlHelper.controller(controllerName, action, data), attrs);
	} 
	
	public function linkornot(text : String, url : String, ?attrs : Dynamic)
	{
		if(null == attrs)
			attrs = {};
		if(url == urlHelper.current())
		{
			return open("span", attrs) + text + close("span");
		} else {
			attrs.href = url; 
	   		return open("a", attrs) + text + close("a");
   		}
	}   
	
	public function actionornot(text : String, name : String, ?data : Dynamic, ?attrs : Dynamic)
	{           
		return linkornot(text, urlHelper.action(name, data), attrs);
	}
	
	public function controllerornot(text : String, controllerName : String, ?action : String, ?data : Dynamic, ?attrs : Dynamic)
	{           
		return linkornot(text, urlHelper.controller(controllerName, action, data), attrs);
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
	
	public function getHelperFieldNames()
	{
		return ["link", "linkornot", "action", "actionornot", "controller", "controllerornot", "encode", "attributeEncode", "tag", "open", "close"];
	}
}
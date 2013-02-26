package ufront.web.module;
import ufront.web.error.HttpError;
import ufront.web.mvc.ViewResult;      
import ufront.web.routing.RequestContext; 
import ufront.web.mvc.Controller;
import thx.error.Error;  
import haxe.CallStack;

class ErrorController extends Controller
{
	public function new()
	{
		super();
	}           
	    
	function _errorView(error : HttpError, showStack = false)
	{                               
		controllerContext.httpContext.response.status = error.code; 
		
		var inner = null != error.inner ? '<p>' + error.inner.toString() + '<p>' : "";
		var items = _errorStack();
		var stack = showStack && items.length > 0 ? '<div><p><i>error stack:</i></p>\n<ul><li>' + items.join("</li><li>") + '</li></ul></div>' : '';
		return  	
'<!doctype html>
<html>
<head>
<title>' + error.toString() + '</title>
<style>
body { text-align: center;}
h1 { font-size: 50px; }
body { font: 20px Constantia, "Hoefler Text",  "Adobe Caslon Pro", Baskerville, Georgia, Times, serif; color: #999; text-shadow: 2px 2px 2px rgba(200, 200, 200, 0.5)}
a { color: rgb(36, 109, 56); text-decoration:none; }
a:hover { color: rgb(96, 73, 141) ; text-shadow: 2px 2px 2px rgba(36, 109, 56, 0.5) }
span[frown] { transform: rotate(90deg); display:inline-block; color: #bbb; }
</style>
</head>
<bofy>
<details>
  <summary><h1>' + error.toString() + '</h1></summary>  
  ' + inner + stack + ' 
  <p><span frown>:(</p>
</details>
</body>
</html>';
		
		/*
		var view = new ViewResult();
		view.viewName = "error";
		view.viewData.set("title", error.toString());   
		if(null != error.inner)
			view.viewData.set("description", error.inner.toString());   
		view.viewData.set("stack", _errorStack());
		return view;
		*/
	}
	   
	private static function _stackItemToString(s:StackItem) {
		switch( s ) {
		case Module(m):
			return "module " + m;
		case CFunction:
			return "a C function";
		case FilePos(s,file,line):
			var r = "";
			if( s != null ) {
				r += _stackItemToString(s) + " (";
			}
			r += file + " line " + line;
			if( s != null ) 
				r += ")";
			return r;
		case Method(cname,meth):
			return cname + "." + meth;
		case Lambda(n):
			return "local function #" + n;
		}
	}
	
	function _errorStack() : Array<String>
	{
		var arr = [];
		var stack = haxe.CallStack.exceptionStack();
#if php
		stack.pop();
		stack = stack.slice(2);
#end
		for(item in stack)      
		{
			arr.push(_stackItemToString(item));
		}            
		return arr;
	}
	
	public function internalServerError(error : HttpError)
	{                 
		return _errorView(error, true);   
	} 
	
	public function badRequestError(error : HttpError)
	{   
	   return _errorView(error);          
	}
	
	public function unauthorizedError(error : HttpError)
	{   
	   return _errorView(error);           
	}
	
	public function pageNotFoundError(error : HttpError)
	{   
		return _errorView(error);      
	}     
	
	public function methodNotAllowedError(error : HttpError)
	{   
		return _errorView(error);         
	}   
	
	public function unprocessableEntityErrory(error : HttpError)
	{   
		return _errorView(error);                   
	}
}
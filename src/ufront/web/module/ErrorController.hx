package ufront.web.module;
import ufront.web.error.HttpError;
import ufront.web.mvc.ViewResult;      
import ufront.web.routing.RequestContext; 
import ufront.web.mvc.Controller;
import thx.error.Error;  
import haxe.Stack; 

class ErrorController extends Controller
{
	public function new()
	{
		super();
	}           
	    
	function _errorView(error : HttpError)
	{                               
		controllerContext.httpContext.response.status = error.code;
		var view = new ViewResult();
		view.viewName = "error";
		view.viewData.set("title", error.toString());   
		if(null != error.inner)
			view.viewData.set("description", error.inner.toString());   
		view.viewData.set("stack", _errorStack());
		return view;
	}
	   
	private static function _stackItemToString(s) {
		switch( s ) {
		case CFunction:
			return "a C function";
		case Module(m):
			return "module " + m;
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
		var stack = haxe.Stack.exceptionStack();
		stack.pop();
		stack = stack.slice(2);
		for(item in stack)      
		{
			arr.push(_stackItemToString(item));
		}            
		return arr;
	}
	
	public function internalServerError(error : HttpError)
	{                 
		return _errorView(error);   
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
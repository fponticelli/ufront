package ufront.web.mvc;
import ufront.web.mvc.ActionResult;
import udo.type.UType;
import udo.error.Error;
import udo.type.URtti;
import ufront.web.mvc.ControllerContext;
import haxe.rtti.CType;

class MethodInvoker
{                               
	public function new()
	{
		_jugglers = new Hash();   
		    
		registerTypeJuggler("String", function(s : String) return s);
		registerTypeJuggler("Int",   Std.parseInt);
		registerTypeJuggler("Float", Std.parseFloat);
		registerTypeJuggler("Bool",  function(s : String) {
			switch(s.toLowerCase())
			{
				case "true", "1", "yes", "y", "ok", "on":
					return true;
				case "false", "0", "no", "n", "off":     
					return false;
				default:
					return null;
					
			}
		});    
		registerTypeJuggler("Date", Date.fromString); 

		// Arrays
		registerTypeJuggler("Array<String>", callback(arraySplitter, "String"));
		registerTypeJuggler("Array<Int>", callback(arraySplitter, "Int"));
		registerTypeJuggler("Array<Float>", callback(arraySplitter, "Float"));
		registerTypeJuggler("Array<Bool>", callback(arraySplitter, "Bool"));
		registerTypeJuggler("Array<Date>", callback(arraySplitter, "Date"));
	} 
	
	public function arraySplitter(type : String, s : String)
	{
		var arr = [];
		var parts = s.split(",");
		for(part in parts)
		{
			var juggler = _jugglers.get(type); 
			if(null == juggler)
				return null;
			var value = juggler(part);
		   	if(null == value)
				return null;
		   	arr.push(value);
		}
		return arr;
	}
	                                 
	public var error(default, null) : Error;   
	
	public function invoke(controller : Controller, action : String, controllerContext : ControllerContext)  
	{        
		error = null; 
		var fields = URtti.getClassFields(Type.getClass(controller));
		var method = fields.get(action); 
		if(null == method)
		{
			error = new Error("action {0} does not exist on this controller", action);
			return false;
		}
		                                                        
		if(!method.isPublic)
		{
			error = new Error("action {0} must be a public method", action);
			return false;
		}
		var argsinfo = URtti.methodArguments(method);
		if(null == argsinfo)
		{
			error = new Error("action {0} is not a method", action);
			return false;
		}	             
		
		var arguments = [];                                                                 
		for(info in argsinfo)
		{                                                  
			var value = controllerContext.requestContext.routeData.get(info.name);
			if(null == value)
				value = controllerContext.requestContext.httpContext.request.query.get(info.name);
			if(null == value)
				value = controllerContext.requestContext.httpContext.request.post.get(info.name);
			if(null == value)
			{
				if(URtti.argumentAcceptNull(info))
				{
					arguments.push(null);
				} else {
					error = new Error("argument {0} cannot be null", info.name);
					return false;
				}
			} else {
				var argvalue = juggle(value, info.t);
				if(null == argvalue)
				{
					error = new Error("the string '{0}' can't be converted into a value of type {1}", [value, URtti.typeName(info.t, false)]);
					return false;
				}
				arguments.push(argvalue);
			}
		}
		
		var returnValue = Reflect.callMethod(controller, Reflect.field(controller, action), arguments);  
		
		if(null != returnValue && Std.is(returnValue, ActionResult))
		{
			var result : ActionResult = cast returnValue;
			result.executeResult(controllerContext);
		}
		              
		return true;
	} 
	
	var _jugglers : Hash<String -> Dynamic>;
	public function registerTypeJuggler(typeName : String, method : String -> Dynamic)
	{
		_jugglers.set(typeName, method);
	}                                   
	       
	public function getTypeJuggler(t : CType)
	{                               
		var type = URtti.typeName(t, false);
		return _jugglers.get(type);   
	}
	
	public function juggle(value : String, t : CType) : Dynamic
	{
		var juggler = getTypeJuggler(t);
		if(null == juggler)
			return null;
		else    
		{
			try {
				return juggler(value);
			} catch(e : Dynamic) {
				return null;
			}
		}
	}
}
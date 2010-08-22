package ufront.web.mvc;
import ufront.web.mvc.ActionResult;
import udo.type.UType;
import udo.error.Error;
import udo.type.URtti;
import ufront.web.mvc.ControllerContext;
import haxe.rtti.CType;         
import udo.collections.Set;  

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
#if php
    	if(_mapper.exists(action))
			action = "h" + action;
#end
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
	
	public function _ctypeCheck(value : Dynamic, t : CType)
	{
		switch(t)
		{
			case CUnknown, CFunction(_, _):	
				return false;
			case CEnum(name, params):    
				var e = Type.resolveEnum(name);
				if(null == e)
					return false;
				if(!Std.is(value, e))
					return false;  
				var values = Type.enumParameters(value);
				if(values.length != params.length)
					return false;        
				var i = 0;
				for(param in params)     
					if(_ctypeCheck(values[i++], param))
						return false;
			case CClass(name, params): 
				var c = Type.resolveClass(name);
				if(null == c)
					return false;
				if(!Std.is(value, c))
					return false;
			case CTypedef(name, params):
				if("Null" == name)
					return _ctypeCheck(value, params.first());
				else
					return false;
		   	case CAnonymous(fields):
				var valueFields = Reflect.fields(value);
				for(field in fields)
				{
					if(!valueFields.remove(field.name))
						return false;
					if(!_ctypeCheck(Reflect.field(value, field.name), field.t))
						return false;
				}   
				if(valueFields.length > 0)
					return false;
			case CDynamic(t):
				if(!Reflect.isObject(value))
					return false;
				if(null != t)
				{
					for(field in Reflect.fields(value))
					{
						if(!_ctypeCheck(Reflect.field(value, field), t))
							return false;
					}
				}
		} 
		return true;
	}
	
	public function juggle(value : String, t : CType) : Dynamic
	{
		var juggler = getTypeJuggler(t);
		if(null == juggler) 
		{                             
			var v;
			// try haxe deserialization
			try
			{
				v = haxe.Unserializer.run(value);
			} catch(e : Dynamic) {
				return null;         
			}
			if(_ctypeCheck(v, t))
				return v;
			else
				return null;
		} else    
		{
			try {
				return juggler(value);
			} catch(e : Dynamic) {
				return null;
			}
		}
	}   
	
#if php
	static var _mapper : Set<String>; 
    static function __init__()
	{
		_mapper = new Set();
		_mapper.add("and");
		_mapper.add("or");
		_mapper.add("xor");
		_mapper.add("exception");
		_mapper.add("array");
		_mapper.add("as");
		_mapper.add("const");
		_mapper.add("declare");
		_mapper.add("die");
		_mapper.add("echo");
		_mapper.add("elseif");
		_mapper.add("empty");
		_mapper.add("enddeclare");
		_mapper.add("endfor");
		_mapper.add("endforeach");
		_mapper.add("endif");
		_mapper.add("endswitch");
		_mapper.add("endwhile");
		_mapper.add("eval");
		_mapper.add("exit");
		_mapper.add("foreach");
		_mapper.add("global");
		_mapper.add("include");
		_mapper.add("include_once");
		_mapper.add("isset");
		_mapper.add("list");
		_mapper.add("print");
		_mapper.add("require");
		_mapper.add("require_once");
		_mapper.add("unset");
		_mapper.add("use");
		_mapper.add("final");
		_mapper.add("php_user_filter");
		_mapper.add("protected");
		_mapper.add("abstract");
		_mapper.add("__set");
		_mapper.add("__get");
		_mapper.add("__call");
		_mapper.add("clone"); 
	}
#end
}
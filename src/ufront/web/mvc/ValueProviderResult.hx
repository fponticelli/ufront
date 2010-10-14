package ufront.web.mvc;

import haxe.rtti.CType;
import thx.collections.Set;
import thx.type.URtti;

/**
 * ...
 * @author Andreas Soderlund
 */

class ValueProviderResult 
{
	static var _jugglers : Hash<String -> Dynamic>;

	public var rawValue(default, null) : Dynamic;
	public var attemptedValue(default, null) : String;
		
	public function new(rawValue : Dynamic, attemptedValue : String) // TODO: Culture
	{
		this.rawValue = rawValue;
		this.attemptedValue = attemptedValue;		
	}
	
	public static function arraySplitter(type : String, s : String)
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
	
	public static function registerTypeJuggler(typeName : String, method : String -> Dynamic)
	{
		_jugglers.set(typeName, method);
	}                                   
	       
	public static function getTypeJuggler(t : CType)
	{                               
		var type = URtti.typeName(t, false);
		return _jugglers.get(type);   
	}
	
	static function _ctypeCheck(value : Dynamic, t : CType)
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
	
	static function initJugglers()
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
	
	public static function convertSimpleType(value : String, t : CType) : Dynamic
	{
		if (_jugglers == null) initJugglers();
		
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
}
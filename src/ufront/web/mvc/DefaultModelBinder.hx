package ufront.web.mvc;
import thx.error.Error;
import thx.type.Rttis;

/**
 * ...
 * @author Andreas Soderlund
 */

class DefaultModelBinder implements IModelBinder
{
	public function new(){}
	
	public function bindModel(controllerContext : ControllerContext, bindingContext : ModelBindingContext) : Dynamic
	{
		var value = bindingContext.valueProvider.getValue(bindingContext.modelName);
		var typeName = bindingContext.modelType;

		if (value == null || value.rawValue == null)
		{
			//trace("Key '" + bindingContext.modelName + "' (" + typeName + ") not found in valueprovider.");
		}
		
		if (isSimpleType(typeName))
		{
			if (value == null) return null;
			if (value.rawValue == null) return value.rawValue;
			
			//trace("Simple bind: Key '" + bindingContext.modelName + "' (" + typeName + ") with value " + value.rawValue);
			
			// TODO: Unserialize based on filter/metadata
			if (bindingContext.ctype != null)
				return ValueProviderResult.convertSimpleTypeRtti(value.attemptedValue, bindingContext.ctype, false);
			else
				return ValueProviderResult.convertSimpleType(value.attemptedValue, typeName);
		}
		
		var enumType = Type.resolveEnum(typeName);
		if (enumType != null)
		{
			return ValueProviderResult.convertEnum(value.attemptedValue, enumType);
		}

		//trace("Complex bind: Key '" + bindingContext.modelName + "' (" + typeName + ")");
		
		// TODO: Binding for Enums
		var classType = Type.resolveClass(typeName);
//		trace(classType);
		
		if (classType == null) throw new Error("Could not bind to class " + typeName);
		
		// TODO: check this is correct
		if (null != value && null != value.rawValue)
		{
			try
			{
				var v = haxe.Unserializer.run(value.rawValue);
				if(Std.is(v, classType))
					return v;
			} catch(e : Dynamic){ }
		}
		if (!Rttis.hasInfo(classType)) return null;
		
		var model = Type.createInstance(classType, []);
		var fields = Rttis.getClassFields(classType);
		
		for (f in fields)
		{
			if (Rttis.isMethod(f)) continue;
			
			var typeName = Rttis.typeName(f.type, false);
			var context = new ModelBindingContext(f.name, typeName, bindingContext.valueProvider, f.type);
			
			Reflect.setField(model, f.name, bindModel(controllerContext, context));
		}
		
		return model;
	}
	
	function isSimpleType(typeName : String) : Bool
	{
		return ValueProviderResult.jugglers.exists(typeName);
	}
}
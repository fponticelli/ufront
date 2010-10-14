package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

class DefaultModelBinder implements IModelBinder
{
	//public var binders : ModelBinderDictionary;
	
	public function new()
	{
	}
	
	public function bindModel(controllerContext : ControllerContext, bindingContext : ModelBindingContext) : Dynamic
	{
		var value = bindingContext.valueProvider.getValue(bindingContext.modelName);

		/*
		if (value != null)
		{
			trace("Binding '" + bindingContext.modelName + "' (" + bindingContext.modelType + ") with value " + value.rawValue);
		}
		else
		{
			trace("Binding '" + bindingContext.modelName + "' (" + bindingContext.modelType + ") not found");
		}
		*/
		
		// TODO: Binding of complex models.
		if (value == null) return null;
		if (value.rawValue == null) return value.rawValue;
		
		return ValueProviderResult.convertSimpleType(value.attemptedValue, bindingContext.modelTypeInfo);
	}
}
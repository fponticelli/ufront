package ufront.web.mvc;
import haxe.rtti.CType;

/**
 * ...
 * @author Andreas Soderlund
 */
class ModelBindingContext 
{
	public var modelName : String;
	public var modelType : Class<Dynamic>;
	public var modelTypeInfo : CType;
	public var valueProvider : IValueProvider;

	public function new(modelName : String, modelType : Class<Dynamic>, modelTypeInfo : CType, valueProvider : IValueProvider)
	{
		this.modelName = modelName;
		this.modelType = modelType;
		this.modelTypeInfo = modelTypeInfo;
		this.valueProvider = valueProvider;
	}	
}
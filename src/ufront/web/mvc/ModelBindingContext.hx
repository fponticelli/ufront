package ufront.web.mvc;
import haxe.rtti.CType;

/**
 * ...
 * @author Andreas Soderlund
 */
class ModelBindingContext
{
	public var modelName : String;
	public var modelType : String;
	public var valueProvider : IValueProvider;
	public var ctype : CType;

	public function new(modelName : String, modelType : String, valueProvider : IValueProvider, ?ctype : CType)
	{
		this.modelName = modelName;
		this.modelType = modelType;
		this.valueProvider = valueProvider;
		this.ctype = ctype;
	}
}
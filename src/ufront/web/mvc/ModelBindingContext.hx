package ufront.web.mvc;
import haxe.rtti.CType;

/**
 * Provides the context in which a model binder functions.
 * @author Andreas Soderlund
 */
class ModelBindingContext
{
	/** Gets or sets the name of the model. */
	public var modelName : String;

	/** Gets or sets the type of the model. */
	public var modelType : String;

	/** Gets or sets the value provider. */
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
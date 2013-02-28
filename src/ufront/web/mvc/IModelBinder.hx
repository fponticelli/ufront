package ufront.web.mvc;

/**
 * Defines the methods that are required for a model binder. 
 * @author Andreas Soderlund
 */
interface IModelBinder 
{
	function bindModel(controllerContext : ControllerContext, bindingContext : ModelBindingContext) : Dynamic;
}
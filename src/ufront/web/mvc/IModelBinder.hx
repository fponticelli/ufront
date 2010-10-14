package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */
interface IModelBinder 
{
	function bindModel(controllerContext : ControllerContext, bindingContext : ModelBindingContext) : Dynamic;
}
package ufront.web.mvc;

/**
 * Represents a value provider for form values that are contained in a HashValueCollection object.
 * @author Andreas Soderlund
 */

class FormValueProvider extends HashValueProvider<String>
{
	public function new(controllerContext : ControllerContext)
	{
		super(controllerContext.request.post);
	}
}
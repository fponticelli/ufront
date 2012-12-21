package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

class FormValueProvider extends HashValueProvider<String>
{
	public function new(controllerContext : ControllerContext)
	{
		super(controllerContext.request.post);
	}
}
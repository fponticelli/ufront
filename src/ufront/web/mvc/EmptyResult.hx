package ufront.web.mvc;

/**
 * Represents a result that does nothing, such as a controller action method that returns nothing.
 * @author Andreas Soderlund
 */

class EmptyResult extends ActionResult
{
	public function new(){}
	
	override public function executeResult(controllerContext : ControllerContext){}
}
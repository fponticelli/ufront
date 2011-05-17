package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

class EmptyResult extends ActionResult
{
	public function new(){}
	
	override public function executeResult(controllerContext : ControllerContext){}
}
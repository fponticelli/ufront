package ufront.web.mvc;

/**
 * Defines the contract for an action invoker, which is used to invoke an action in response to an HTTP request. 
 * @author Andreas Soderlund
 */
interface IActionInvoker 
{
	function invokeAction(controllerContext : ControllerContext, actionName : String, async : hxevents.Async) : Void;
}
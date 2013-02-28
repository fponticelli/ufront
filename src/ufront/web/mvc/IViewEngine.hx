package ufront.web.mvc;

/** Defines the methods that are required for a view engine. */
interface IViewEngine 
{
	public function findView(controllerContext : ControllerContext, viewName : String) : ViewEngineResult;
	public function releaseView(controllerContext : ControllerContext, view : IView) : Void;
}
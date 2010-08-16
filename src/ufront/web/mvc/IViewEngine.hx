package ufront.web.mvc;

interface IViewEngine 
{
	public function findView(controllerContext : ControllerContext, viewName : String) : ViewEngineResult;
	public function releaseView(controllerContext : ControllerContext, view : IView) : Void;
}
package ufront.web.mvc;

class ViewEngineResult 
{
	public var view(default, null) : IView;
	public var viewEngine(default, null) : IViewEngine;

	public function new(view : IView, viewEngine : IViewEngine)
	{
		this.view = view;
		this.viewEngine = viewEngine;
	}
}
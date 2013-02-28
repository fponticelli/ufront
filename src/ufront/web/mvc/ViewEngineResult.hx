package ufront.web.mvc;

/** Represents the result of locating a view engine. */
class ViewEngineResult 
{
	/** Gets the view */
	public var view(default, null) : IView;

	/** Gets the view engine */
	public var viewEngine(default, null) : IViewEngine;

	public function new(view : IView, viewEngine : IViewEngine)
	{
		this.view = view;
		this.viewEngine = viewEngine;
	}
}
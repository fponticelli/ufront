package ufront.web.mvc;
import ufront.web.mvc.IViewEngine;

/** Represents a collection of view engines that are available to the application. */
class ViewEngines
{
	/** Gets the view engines. */
	public static var engines(get, null) : ViewEngines;

	var _list : List<IViewEngine>;

	function new()
	{
		_list = new List();
	}

	public function add(engine : IViewEngine)
	{
		_list.add(engine);
	}

	public function clear()
	{
		_list = new List();
	}

	public function iterator()
	{
		return _list.iterator();
	}

	static function get_engines()
	{
		if(null == engines)
		{
			engines = new ViewEngines();
#if erazor
			engines.add(new ufront.web.mvc.view.ErazorViewEngine());
#end
#if htemplate
    		engines.add(new ufront.web.mvc.view.HTemplateViewEngine());
#end
		}
		return engines;
	}
}
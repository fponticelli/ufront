package ufront.web.mvc;
import ufront.web.mvc.IViewEngine;

class ViewEngines
{
	public static var engines(getEngines, null) : ViewEngines;

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

	static function getEngines()
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
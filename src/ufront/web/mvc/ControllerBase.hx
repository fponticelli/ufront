package ufront.web.mvc;

import ufront.web.routing.RequestContext;
import ufront.web.mvc.ControllerContext;
//import ufront.web.mvc.view.IViewHelper;

/**
 * ...
 * @author Andreas Soderlund
 */

class ControllerBase implements IController, implements haxe.rtti.Infos
{
	public var controllerContext : ControllerContext;
	
	var _valueProvider : IValueProvider;
	public var valueProvider(getValueProvider, setValueProvider) : IValueProvider;
	private function getValueProvider()
	{
		if (_valueProvider == null)
		{
			// TODO: Move away from singleton
			_valueProvider = ValueProviders.providers(controllerContext);
		}
		
		return _valueProvider;
	}	
	private function setValueProvider(v : IValueProvider)
	{
		_valueProvider = v;
		return _valueProvider;
	}
	
	public function new() { }

	private function executeCore() { throw "Must be overridden in subclass."; }
	
	public function execute(requestContext : RequestContext) : Void
	{
		controllerContext = new ControllerContext(this, requestContext);
		executeCore();
	}
	
	/*
	public function getViewHelpers() : Array<{ name : Null<String>, helper : IViewHelper }>
	{
		return [];
	}
	*/
}
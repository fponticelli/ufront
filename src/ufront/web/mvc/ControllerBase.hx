package ufront.web.mvc;

import thx.error.Error;
import thx.error.NullArgument;
import ufront.web.routing.RequestContext;
import ufront.web.mvc.ControllerContext;
import hxevents.Dispatcher;

/**
 * ...
 * @author Andreas Soderlund
 */

class ControllerBase implements IController, implements haxe.rtti.Infos
{	
	/**
	 * If null, this value is automatically created in execute().
	 */
	public var controllerContext : ControllerContext;
	public var onActionExecuted(default, null) : Dispatcher<ActionExecutedContext>;
	public var onActionExecuting(default, null) : Dispatcher<ActionExecutingContext>;

	var _valueProvider : IValueProvider;
	public var valueProvider(getValueProvider, setValueProvider) : IValueProvider;
	private function getValueProvider()
	{
		if (_valueProvider == null)
			_valueProvider = ValueProviderFactories.factories.getValueProvider(controllerContext);
			
		return _valueProvider;			
	}
	private function setValueProvider(valueProvider : IValueProvider)
	{
		_valueProvider = valueProvider;
		return _valueProvider;
	}
			
	public function new() 
	{
		onActionExecuted = new Dispatcher();
		onActionExecuting = new Dispatcher();
	}

	private function executeCore(async : hxevents.Async) { throw "executeCore() must be overridden in subclass."; }
	
	public function execute(requestContext : RequestContext, async : hxevents.Async) : Void
	{
		NullArgument.throwIfNull(requestContext, "requestContext");
		
		if(controllerContext == null)
			controllerContext = new ControllerContext(this, requestContext);

		executeCore(async);
	}
	
	public function getViewHelpers() : Array<{ name : Null<String>, helper : Dynamic }>
	{
		return [];
	}
}

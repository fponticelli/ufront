/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;

class TestHttpApplication extends HttpApplication
{
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestHttpApplication());
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
	
	public function new()
	{
		var context = HttpContext.createWebContext();
		super(context);
	}
	
	public function testSequence()
	{
		var mock = new MockEventsModule();
		modules.add(mock);
		
		Assert.same([], mock.triggeredEvents);
		
		init();
		
		Assert.same(["begin", "resolvecache", "afterresolvecache", "handler", "afterhandler", "updatecache", "afterupdatecache", "log", "afterlog", "end"], mock.triggeredEvents);
		Assert.isFalse(mock.disposed);
		
		dispose();
		Assert.isTrue(mock.disposed);
	}
	
	public function testInterruptedChain()
	{
		var mock = new MockEventsModule(true);
		modules.add(mock);
		init();
		Assert.same(["begin", "resolvecache", "afterresolvecache", "handler", "end"], mock.triggeredEvents);
	} 
	
	override function _executeRoute();
}

private class MockEventsModule implements IHttpModule
{
	public var disposed : Bool;
	public var triggeredEvents : Array<String>;
	public var crashOnHandler : Bool;
	public function new(crashonhandler = false)
	{
		disposed = false;
		triggeredEvents = [];
		crashOnHandler = crashonhandler;
	}
	
	public function init(application : HttpApplication)
	{
		var events = triggeredEvents;
		var crashonhandler = crashOnHandler;
		application.onBegin.add(function (_) events.push("begin"));
		application.onEnd.add(function (_) events.push("end"));
		
		application.onResolveCache.add(function (_) events.push("resolvecache"));
		application.onAfterResolveCache.add(function (_) events.push("afterresolvecache"));
		application.onHandler.add(function (_)
		{
			events.push("handler");
			if(crashonhandler)
				application.completeRequest();
		});
		application.onAfterHandler.add(function (_) events.push("afterhandler"));
		application.onUpdateCache.add(function (_) events.push("updatecache"));
		application.onAfterUpdateCache.add(function (_) events.push("afterupdatecache"));
		application.onLog.add(function (_) events.push("log"));
		application.onAfterLog.add(function (_) events.push("afterlog"));
	}
	
	public function dispose()
	{
		disposed = true;
	}
}
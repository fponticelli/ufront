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
		
		var eventChain = ["begin",
						"resolvecache",
						"afterresolvecache",
						"handler",
						"afterhandler",
						"acquireRequestState",
						"postAcquireRequestState",
						"preRequestHandlerExecute",
						"postRequestHandlerExecute",
						"releaseRequestState",
						"postReleaseRequestState",
						"updatecache",
						"afterupdatecache",
						"log",
						"afterlog",
						"end"];
		
		Assert.same(eventChain, mock.triggeredEvents);
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
		
		application.beginRequest.add(function (_) events.push("begin"));
		
		application.resolveRequestCache.add(function (_) events.push("resolvecache"));
		application.postResolveRequestCache.add(function (_) events.push("afterresolvecache"));
		application.mapRequestHandler.add(function (_)
		{
			events.push("handler");
			if(crashonhandler)
				application.completeRequest();
		});
		application.postMapRequestHandler.add(function (_) events.push("afterhandler"));
		application.acquireRequestState.add(function (_) events.push("acquireRequestState"));
		application.postAcquireRequestState.add(function (_) events.push("postAcquireRequestState"));
		application.preRequestHandlerExecute.add(function (_) events.push("preRequestHandlerExecute"));
		application.postRequestHandlerExecute.add(function (_) events.push("postRequestHandlerExecute"));
		application.releaseRequestState.add(function (_) events.push("releaseRequestState"));
		application.postReleaseRequestState.add(function (_) events.push("postReleaseRequestState"));
		application.updateRequestCache.add(function (_) events.push("updatecache"));
		application.postUpdateRequestCache.add(function (_) events.push("afterupdatecache"));
		application.logRequest.add(function (_) events.push("log"));
		application.postLogRequest.add(function (_) events.push("afterlog"));
		
		application.endRequest.add(function (_) events.push("end"));
	}
	
	public function dispose()
	{
		disposed = true;
	}
}
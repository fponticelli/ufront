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
		var context = new HttpContextMock();
		super(context);
	}
	
	public function testSequence()
	{
		var mock = new MockEventsModule();
		modules.add(mock);
		
		Assert.same([], mock.triggeredEvents);
		
		execute();
		
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
//		Assert.isFalse(mock.disposed);
		
//		dispose();
		Assert.isTrue(mock.disposed);
	}
	
	public function testInterruptedChain()
	{
		var mock = new MockEventsModule(true);
		modules.add(mock);
		execute();
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
		
		application.onBeginRequest.add(function (_) events.push("begin"));
		
		application.onResolveRequestCache.add(function (_) events.push("resolvecache"));
		application.onPostResolveRequestCache.add(function (_) events.push("afterresolvecache"));
		application.onMapRequestHandler.add(function (_)
		{
			events.push("handler");
			if(crashonhandler)
				application.completeRequest();
		});
		application.onPostMapRequestHandler.add(function (_) events.push("afterhandler"));
		application.onAcquireRequestState.add(function (_) events.push("acquireRequestState"));
		application.onPostAcquireRequestState.add(function (_) events.push("postAcquireRequestState"));
		application.onPreRequestHandlerExecute.add(function (_) events.push("preRequestHandlerExecute"));
		application.onPostRequestHandlerExecute.add(function (_) events.push("postRequestHandlerExecute"));
		application.onReleaseRequestState.add(function (_) events.push("releaseRequestState"));
		application.onPostReleaseRequestState.add(function (_) events.push("postReleaseRequestState"));
		application.onUpdateRequestCache.add(function (_) events.push("updatecache"));
		application.onPostUpdateRequestCache.add(function (_) events.push("afterupdatecache"));
		application.onLogRequest.add(function (_) events.push("log"));
		application.onPostLogRequest.add(function (_) events.push("afterlog"));
		
		application.onEndRequest.add(function (_) events.push("end"));
	}
	
	public function dispose()
	{
		disposed = true;
	}
}
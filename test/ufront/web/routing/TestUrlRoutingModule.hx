package ufront.web.routing;

import hxevents.Dispatcher;
import ufront.web.HttpApplication;
import ufront.web.HttpContext;
import ufront.web.HttpContextMock;
import ufront.web.HttpRequestMock;
import ufront.web.IHttpHandler;
#if umock
import umock.Mock;
#end
import utest.Assert;
import utest.Runner;
import utest.ui.Report;

/**
 * ...
 * @author Andreas Soderlund
 */

class TestUrlRoutingModule extends HttpApplication
{
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestUrlRoutingModule());
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
	
	public function new(?httpContext : HttpContext)
	{ 
		super(httpContext != null ? httpContext : new HttpContextMock());
	}
#if umock	
	public function testEventWiring()
	{
		var httpHandler = new Mock<IHttpHandler>(IHttpHandler);		
		var app = setupRequest("/", ["/"], httpHandler);
		
		// Run the app
		app.execute();
		
		httpHandler.verify("processRequest", Times.once());
		Assert.isTrue(true);
	}
	
	public function testNoRouteMatchThrows()
	{
		var app = setupRequest("/mismatch", ["/{controller}/{action}"], new Mock<IHttpHandler>(IHttpHandler));
		
		Assert.raises(function() { app.execute(); }, ufront.web.error.PageNotFoundError);
	}
	
	function setupRequest(url : String, routeStrings : Array<String>, httpHandler : Mock<IHttpHandler>) : HttpApplication
	{
		// Create mock objects for http and routeHandler
		var routeHandler = new Mock<IRouteHandler>(IRouteHandler);
		
		routeHandler.setupMethod("get_httpHandler").returns(httpHandler.object);
		httpHandler.setupMethod("processRequest");

		var routes = Lambda.fold(routeStrings, 
			function(route : String, collection : RouteCollection)
			{ 
				collection.add(new Route(route, routeHandler.object));
				return collection;
			}, 
			new RouteCollection()
		);

		// Make a mock request for the root url
		var mockRequest = new HttpRequestMock();
		mockRequest.set_queryString(url);
				
		// Setup the application with the mock objects and the UrlRoutingModule.
		var app = new TestUrlRoutingModule(new HttpContextMock(mockRequest));		
		
		app.modules.add(new UrlRoutingModule(routes));
		
		return app;
	}    
#end
}
package ufront.web.mvc;
import ufront.web.HttpResponseMock;
import thx.error.Error;
import ufront.web.mvc.TestDefaultControllerFactory;
import ufront.web.routing.RequestContext;
import ufront.web.routing.TestUrlRoutingModule;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;

// forces the inclusions of the test controllers
import ufront.web.mvc.test.MockController;
import ufront.web.mvc.MockController; 
import ufront.web.mvc.Controller;

private class TestController extends Controller
{
	public var auth : AuthorizationContext -> Void;	
	public var handler : Void -> Void;
	public function new()
	{
		super();
	}
	
	public function index(?id : Int)
	{
    	if(null != handler)
			handler();
		return "content";
	}
	
	override function onAuthorization(context : AuthorizationContext)
	{
		auth(context);
	}
}

class TestIAuthorizationFilter
{   
	public function testAuthorizationOverridesAction()
	{
		var authResult : ActionResult = null;
		
		controller.auth = function(context : AuthorizationContext)
		{
			Assert.isNull(context.result);
			
			context.result = new ContentResult("eventcontent");
			authResult = context.result;
		}
		
		controller.handler = function()
		{
			Assert.fail("should never reach this point");
		}
		
		execute();
		
		Assert.equals("eventcontent", cast(authResult, ContentResult).content);
	}
		
	public function testAuthorizationArguments()
	{  
		context.routeData.data.set("id", "1");
		
		controller.auth = function(e)
		{
			Assert.notNull(e.controllerContext);
			Assert.notNull(e.actionParameters);
			Assert.equals("index", e.actionName);
			Assert.equals(1, e.actionParameters.get("id"));
		};
		
		execute();
	}
	    
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestIAuthorizationFilter());
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
	
	public function new()
	{}

	var controller : TestController;
	var context : RequestContext;
	
	public function setup()
	{
		context = TestAll.getRequestContext();
		controller = new TestController();

		var valueProvider = new RouteDataValueProvider(new ControllerContext(controller, context));		
		controller.invoker = new ControllerActionInvoker(new ModelBinderDictionary(), ControllerBuilder.current, new DefaultDependencyResolver());
	} 
	
	function execute()
	{
		controller.execute(context, new hxevents.Async(function(){}));
	}
}
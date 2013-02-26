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
	public var sequence : Array<Int>;
	
	public var handler : Void -> Void;
	public function new()
	{
		this.sequence = [];
		super();
	}
	
	public function index(?id : Int)
	{
		sequence.push(2);
		
    	if(null != handler)
			handler();
			
		return "content";
	}
	
	override function onAuthorization(filterContext : AuthorizationContext)
	{
		sequence.push(0);
	}

	override function onActionExecuting(filterContext : ActionExecutingContext)
	{
		sequence.push(1);
	}
	
	override function onActionExecuted(filterContext : ActionExecutedContext)
	{
		sequence.push(3);
	}

	override function onResultExecuting(filterContext : ResultExecutingContext)
	{
		sequence.push(4);
	}
	
	override function onResultExecuted(filterContext : ResultExecutedContext)
	{
		sequence.push(5);
	}
}

private class TestFailAuthController extends TestController
{
	public function new() { super(); }
	
	override function onAuthorization(filterContext : AuthorizationContext)
	{
		super.onAuthorization(filterContext);
		filterContext.result = new HttpUnauthorizedResult();
	}	
}

class TestControllerFilters
{   
	public function testEventsSequence()
	{
		execute();
		Assert.equals(6, controller.sequence.length);
		Assert.same([0,1,2,3,4,5], controller.sequence);
	}
	
	public function testEventsSequenceWhenAuthorizationBlocksTheResult()
	{
		setupController(new TestFailAuthController());		
		execute();
		
		Assert.same([0], controller.sequence);
	}
	
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestControllerFilters());
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
		setupController(null);
	} 
	
	public function setupController(?controller : TestController)
	{
		context = TestAll.getRequestContext();
		this.controller = controller == null ? new TestController() : controller;

		var valueProvider = new RouteDataValueProvider(new ControllerContext(this.controller, context));
		this.controller.invoker = new ControllerActionInvoker(new ModelBinderDictionary(), ControllerBuilder.current, new DefaultDependencyResolver());
	} 
	
	function execute()
	{
		controller.execute(context, new hxevents.Async(function(){}));
	}
}
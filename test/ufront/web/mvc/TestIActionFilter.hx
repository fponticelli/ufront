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
	public var executing : ActionExecutingContext -> Void;
	public var executed : ActionExecutedContext -> Void;
	
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
	
	override function onActionExecuting(filterContext : ActionExecutingContext)
	{
		if(executing != null)
			executing(filterContext);
	}
	
	override function onActionExecuted(filterContext : ActionExecutedContext)
	{
		if(executed != null)
			executed(filterContext);
	}
}

class TestIActionFilter
{   
	public function testActionExecutingArguments()
	{   
		context.routeData.data.set("id", "1");
		controller.executing = function(e : ActionExecutingContext)
		{
			Assert.notNull(e.controllerContext);
			Assert.notNull(e.actionParameters);
			Assert.equals("index", e.actionName);
			Assert.equals(1, e.actionParameters.get("id"));
		};
		
		execute(); 
	}
	
	public function testActionExecutedArguments()
	{
		context.routeData.data.set("id", "1");   
		controller.executed = function(e : ActionExecutedContext)
		{
			Assert.notNull(e.controllerContext);
			Assert.equals("content", cast(e.result, ContentResult).content);
		};
		
		execute();
	}
	    
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestIActionFilter());
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
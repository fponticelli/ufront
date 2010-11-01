package ufront.web.mvc;
import ufront.web.HttpResponseMock;
import haxe.rtti.Infos;
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
}

class TestIActionFilter
{   
	public function testActionExecutingOverridesAction()
	{
		controller.onActionExecuting.add(function(e : ActionExecutingContext){
			Assert.isNull(e.result);
			e.result = "eventcontent";
		});       
		controller.handler = function()
		{
			Assert.fail("should never reach this point");
		}
		execute();
		var response = cast(controller.controllerContext.response, HttpResponseMock);
		Assert.equals("eventcontent", response.getBuffer());
	}
	
	public function testEventsSequence()
	{                                    
		var sequence = [];
		controller.onActionExecuting.add(function(_) sequence.push(0));
		controller.onActionExecuted.add(function(_) sequence.push(2));
		controller.handler = function() sequence.push(1);
		execute();
		Assert.same([0,1,2], sequence);
	}
	
	public function testActionExecutingArguments()
	{   
		context.routeData.data.set("id", "1");
		controller.onActionExecuting.add(function(e : ActionExecutingContext){
			Assert.notNull(e.controllerContext);
			Assert.notNull(e.actionParameters);
			Assert.equals("index", e.actionName);
			Assert.equals(1, e.actionParameters.get("id"));
		});
		execute(); 
	}
	
	public function testActionExecutedArguments()
	{
		context.routeData.data.set("id", "1");   
		controller.onActionExecuted.add(function(e : ActionExecutedContext){
			Assert.notNull(e.controllerContext);
			Assert.equals("content", e.result);
		});
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
		controller.invoker = new ControllerActionInvoker(new ModelBinderDictionary());
	} 
	
	function execute()
	{
		controller.execute(context, new hxevents.Async(function(){}));
	}
}
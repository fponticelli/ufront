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

class TestIResultFilter
{   
	public function testEventsSequence()
	{                             
		var sequence = [];
		controller.onResultExecuting.add(function(_) sequence.push(0));
		controller.onResultExecuted.add(function(_) sequence.push(1));
		execute();
		Assert.same([0,1], sequence);
	}
	
	public function testResultValue()
	{  
		controller.onResultExecuting.add(function(e){
			Assert.notNull(e.controllerContext);
			Assert.equals("content", e.result);
			e.result = "modifiedcontent";
		}); 
		
		controller.onResultExecuted.add(function(e){
			Assert.notNull(e.controllerContext);
			Assert.equals("modifiedcontent", e.result);
		});
		execute();
	}
	    
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestIResultFilter());
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
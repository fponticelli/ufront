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

class TestControllerFilters
{   
	public function testEventsSequence()
	{                                   
		var sequence = [];
		controller.onAuthorization.add(function(_) sequence.push(0)); 
		controller.onActionExecuting.add(function(_) sequence.push(1));
		controller.handler = function() sequence.push(2);
		controller.onActionExecuted.add(function(_) sequence.push(3)); 
		controller.onResultExecuting.add(function(_) sequence.push(4));
		controller.onResultExecuted.add(function(_) sequence.push(5));
		execute();
		Assert.same([0,1,2,3,4,5], sequence);
	}
	
	public function testEventsSequenceWhenAuthorizationBlocksTheResult()
	{                                   
		var sequence = [];
		controller.onAuthorization.add(function(e) {
			e.result = "authorization";
			sequence.push(0);
		}); 
		controller.onActionExecuting.add(function(_) sequence.push(1));
		controller.handler = function() sequence.push(2);
		controller.onActionExecuted.add(function(_) sequence.push(3)); 
		controller.onResultExecuting.add(function(_) sequence.push(4));
		controller.onResultExecuted.add(function(_) sequence.push(5));
		execute();
		Assert.same([0,4,5], sequence);
	}
	
	public function testEventsSequenceWhenActionExecutingBlocksTheResult()
	{                                   
		var sequence = [];
		controller.onAuthorization.add(function(_) sequence.push(0)); 
		controller.onActionExecuting.add(function(e) {
			e.result = "actionexecuting";
			sequence.push(1);
		});
		controller.handler = function() sequence.push(2);
		controller.onActionExecuted.add(function(_) sequence.push(3)); 
		controller.onResultExecuting.add(function(_) sequence.push(4));
		controller.onResultExecuted.add(function(_) sequence.push(5));
		execute();
		Assert.same([0,1,4,5], sequence);
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

	var controller : ControllerTest;
	var context : RequestContext;
	
	public function setup()
	{
		context = TestAll.getRequestContext();
		controller = new ControllerTest();

		var valueProvider = new RouteDataValueProvider(new ControllerContext(controller, context));		
		controller.invoker = new ControllerActionInvoker(new ModelBinderDictionary());
	} 
	
	function execute()
	{
		controller.execute(context, new hxevents.Async(function(){}));
	}
}
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

///// Attributes ////////////////////////////////////////////////////

// This attribute has no filter type interface so it won't be called
// even though it's added.
private class TestAttributeNoType extends FilterAttribute
{
	
}

private class TestActionAttribute extends FilterAttribute, implements IActionFilter
{
	public function onActionExecuting(filterContext : ActionExecutingContext) : Void
	{
		var c = cast(filterContext.controllerContext.controller, BaseTestController);
		c.sequence.push('executing');
	}
	
	public function onActionExecuted(filterContext : ActionExecutedContext) : Void
	{
		var c = cast(filterContext.controllerContext.controller, BaseTestController);
		c.sequence.push('executed');		
	}
}

///// Controllers ///////////////////////////////////////////////////

private class BaseTestController extends Controller
{
	public var sequence : Array<String>;
	
	public var handler : Void -> Void;
	public function new()
	{
		sequence = [];
		super();
	}
	
	public function index(?id : Int)
	{
    	if(null != handler)
			handler();
		return "content";
	}
}

private class TestControllerMetaData extends BaseTestController
{
	@TestAction
	override public function index(?id : Int)
	{
		return super.index(id);
	}
}

///// Tests /////////////////////////////////////////////////////////

class TestControllerFiltersMetaData
{   
	public function testAttributeAdded()
	{
		var self = this;
		
		controller.handler = function()
		{
			self.controller.sequence.push("handler");
		}
		
		execute();		
		Assert.same(['executing', 'handler', 'executed'], controller.sequence);
	}
	    
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestControllerFiltersMetaData());
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

	var controller : BaseTestController;
	var context : RequestContext;
	
	public function setup()
	{
		context = TestAll.getRequestContext();
		controller = new TestControllerMetaData();

		var valueProvider = new RouteDataValueProvider(new ControllerContext(controller, context));		
		controller.invoker = new ControllerActionInvoker(new ModelBinderDictionary());
	} 
	
	function execute()
	{
		controller.execute(context, new hxevents.Async(function(){}));
	}
}
package ufront.web.mvc;
import thx.error.Error;
import ufront.web.mvc.TestDefaultControllerFactory;
import ufront.web.routing.RequestContext;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;

// forces the inclusions of the test controllers
import ufront.web.mvc.test.MockController;
import ufront.web.mvc.MockController; 
import ufront.web.mvc.Controller;

class TestController extends Controller
{
	public var expected : { id : Int, number : Null<Float>, optional : Null<Bool>, arr : Null<Array<Int>> };
	
	public function new()
	{
		super();
	}
	
	public function index(id : Int, number : Null<Float>, ?optional : Bool, ?arr : Array<Int>)
	{
		Assert.equals(expected.id, id);
		Assert.equals(expected.number, number);
		Assert.equals(expected.optional, optional);
		Assert.same(expected.arr, arr);
	}
}

class TestControllerBindings
{      
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestControllerBindings());
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
	
	public function testControllerArguments1()
	{
		controller.expected = { id : 1, number : 0.1, optional : true, arr : null };
		
		context.routeData.data.set("id", "1");
		context.routeData.data.set("number", "0.1");
		context.routeData.data.set("optional", "YES");
		
		controller.execute(context);
	}
	
	public function testControllerArguments2()
	{
		controller.expected = { id : -1, number : null, optional : null, arr : null };
		
		context.routeData.data.set("id", "-1");
		
		controller.execute(context);
	}
	
	public function testControllerArguments3()
	{
		controller.expected = { id : -1, number : null, optional : null, arr : [2, 1, 0] };
		
		context.routeData.data.set("id", "-1");
		context.routeData.data.set("arr", "2,1,0");
		
		controller.execute(context);
	}
	
	public function testInvalidArgument()
	{
		// The parameters dictionary contains a null entry for parameter 'id' of non-nullable type 'Int' for method 
		// 'Edit(Int)' in 'name.space.ControllerName'.
		// An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
		try
		{
			controller.execute(context);
			
			Assert.fail("No invalid arguments found.");
		}
		catch (e : Error)
		{
			Assert.equals("argument id cannot be null", e.inner.params[0]);
		}		
	}
}
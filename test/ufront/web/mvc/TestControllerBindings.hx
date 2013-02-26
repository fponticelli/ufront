package ufront.web.mvc;
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

class SpecialDateBinder implements IModelBinder
{
	public function new(){}
	
	public function bindModel(controllerContext : ControllerContext, bindingContext : ModelBindingContext) : Dynamic
	{
		var value = bindingContext.valueProvider.getValue(bindingContext.modelName);
		
		if (value.attemptedValue == "Millenium") return Date.fromString("2000-01-01");
		else return null;
	}
}

@:rtti
class DataModel
{
	public function new(){}
	
	public var id : Int;
	public var name : String;
	public var active : Bool;
	public var email : Null<String>;
}

enum TestEnum
{
	First;
	Second;
	Third;
}

private class TestController extends Controller
{
	public var expected : { id : Int, number : Null<Float>, optional : Null<Bool>, arr : Null<Array<Int>> };
	public var expectedModel : DataModel;
	public var expectedEnum : TestEnum;
	public var expectedDate : Date;
	
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
	
	public function bind(model : DataModel)
	{
		Assert.same(expectedModel, model);
	}
	
	public function bindEnum(?test : TestEnum)
	{
		Assert.same(expectedEnum, test);
	}
	
	public function bindDate(?date : Date)
	{
		Assert.same(expectedDate, date);
	}
	
	public override function onException(e)
	{
		throw e;
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
		controller.invoker = new ControllerActionInvoker(new ModelBinderDictionary(), ControllerBuilder.current, new DefaultDependencyResolver());
	} 
	
	function execute()
	{
		controller.execute(context, new hxevents.Async(function() { }, function(e) { throw e; } ));
	}

	public function testControllerArguments1()
	{
		controller.expected = { id : 1, number : 0.1, optional : true, arr : null };
		
		context.routeData.data.set("id", "1");
		context.routeData.data.set("number", "0.1");
		context.routeData.data.set("optional", "YES");
		
		execute();
	}
	
	public function testControllerArguments2()
	{
		controller.expected = { id : -1, number : null, optional : null, arr : null };
		
		context.routeData.data.set("id", "-1");
		
		execute();
	}
	
	public function testControllerArguments3()
	{
		controller.expected = { id : -1, number : null, optional : null, arr : [2, 1, 0] };
		
		context.routeData.data.set("id", "-1");
		context.routeData.data.set("arr", "2,1,0");
		
		execute();
	}

	public function testInvalidArgument()
	{
		// The parameters dictionary contains a null entry for parameter 'id' of non-nullable type 'Int' for method 
		// 'Edit(Int)' in 'name.space.ControllerName'.
		// An optional parameter must be a reference type, a nullable type, or be declared as an optional parameter.
		// TODO: Test is broken it seems
		Assert.raises(execute, Error);  	
	}
 
	public function testComplexModelBinding()
	{
		var model = new DataModel();
		model.active = true;
		model.id = 100;
		model.name = "Mocked";
		
		context.routeData.data.set("action", "bind");
		
		context.routeData.data.set("id", "100");
		context.routeData.data.set("active", "true");
		context.routeData.data.set("name", "Mocked");
		
		controller.expectedModel = model;
		execute();
	}
	
	public function testEnumBinding()
	{
		context.routeData.data.set("action", "bindEnum");		
		context.routeData.data.set("test", "First");
		
		controller.expectedEnum = TestEnum.First;
		execute();
	}
		
	public function testFailedEnumBinding()
	{
		context.routeData.data.set("action", "bindEnum");
		context.routeData.data.set("test", "InvalidValue");
		
		controller.expectedEnum = null;
		execute();
	}
	
	public function testCustomBinder()
	{
		var binders = new ModelBinderDictionary();
		binders.add(Date, new SpecialDateBinder());
		
		controller.invoker = new ControllerActionInvoker(binders, ControllerBuilder.current, new DefaultDependencyResolver());
		
		context.routeData.data.set("action", "bindDate");
		context.routeData.data.set("date", "Millenium");
		
		controller.expectedDate = Date.fromString("2000-01-01");
		
		execute();
	}
	
	public function testCustomBinderFailedBind()
	{
		var binders = new ModelBinderDictionary();
		binders.add(Date, new SpecialDateBinder());
		
		controller.invoker = new ControllerActionInvoker(binders, ControllerBuilder.current, new DefaultDependencyResolver());
		
		context.routeData.data.set("action", "bindDate");
		context.routeData.data.set("date", "Some other value");
		
		controller.expectedDate = null;
		
		execute();
	}
}

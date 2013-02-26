package ufront.web.mvc;

import ufront.web.HttpResponseMock;
import thx.error.Error;
import ufront.web.mvc.TestDefaultControllerFactory;
import ufront.web.routing.RequestContext;
import ufront.web.routing.TestUrlRoutingModule;

import ufront.web.mvc.attributes.TestActionAttribute;
import ufront.web.mvc.attributes.TestAction2Attribute;

import ufront.web.mvc.attributes.TestResultAttribute;
import ufront.web.mvc.attributes.TestResult2Attribute;

import ufront.web.mvc.attributes.AuthFailAttribute;
import ufront.web.mvc.attributes.HandleExceptionAttribute;
import ufront.web.mvc.attributes.FilterAttribute;

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

///// Controllers ///////////////////////////////////////////////////

class BaseTestController extends Controller
{
	public var sequence : Array<String>;
	
	public var handler : Void -> Void;
	public var result : Void -> ActionResult;
	
	public function new()
	{
		sequence = [];
		super();
	}
	
	public function index(?id : Int) : Dynamic
	{
    	if(null != handler)
			handler();
			
		sequence.push("handler");
		
		if (result == null) return "content";
		else return result();
	}
}

private class TestControllerMetaData extends BaseTestController
{
	public function new() { super(); }
	
	@TestAction({id: "OnMethod"})
	@TestAction2({order: 2 })
	@TestResult({id: "OnMethod", order: 2 })
	@TestResult2({order: 1 })
	override public function index(?id : Int)
	{
		return super.index(id);
	}
}

@TestAction
private class TestControllerClassMetaData extends BaseTestController
{
	public function new() { super(); }
	
	override public function index(?id : Int)
	{
		return super.index(id);
	}
}

private class TestControllerSuperClassMetaData extends TestControllerClassMetaData
{
	public function new() { super(); }
	
	override public function index(?id : Int)
	{
		return super.index(id);
	}
}

private class TestControllerSuperClassOverride extends TestControllerClassMetaData
{
	public function new() { super(); }
	
	@TestAction({id: "Override"})
	override public function index(?id : Int)
	{
		return super.index(id);
	}
}

@TestResult // This filter should not run since authorization will fail.
@AuthFail
private class TestControllerAuthFail extends BaseTestController
{
	public function new() { super(); }
}

@HandleException // Won't handle the exception, the handleIt property is false.
private class TestControllerNoRealExceptionHandler extends BaseTestController
{
	public function new() { super(); }
	
	override public function index(?id : Int)
	{
		throw "ERROR";
		return super.index(id);
	}
}

private class TestControllerWithExceptionHandler extends TestControllerNoRealExceptionHandler
{
	public function new() { super(); }
	
	@HandleException({handleIt: true})
	override public function index(?id : Int)
	{
		throw "ERROR AGAIN";
		return super.index(id);
	}
}

///// ActionResult //////////////////////////////////////////////////

class SequenceResult extends ActionResult
{
	public var controller : BaseTestController;
	public var id : String;
	
	public function new(controller : BaseTestController, ?id = "")
	{
		this.controller = controller;
		this.id = id;
	}
	
	override public function executeResult(controllerContext : ControllerContext)
	{
		this.controller.sequence.push("sequenceResult" + id);
	}
}

///// Tests /////////////////////////////////////////////////////////

class TestControllerFiltersMetaData
{   
	public function testAttributeAdded() // Default test is for method
	{
		var self = this;
		
		controller.result = function() {
			return new SequenceResult(self.controller);
		}
		
		execute();
		Assert.same(['executingOnMethod', 'executing2', 
					 'handler', 
					 'executed2', 'executedOnMethod',
					 'result2 executing', 'result executingOnMethod', 
					 'sequenceResult', 
					 'result executedOnMethod', 'result2 executed'], controller.sequence);
	}

	public function testAttributeAddedOnClass()
	{
		// Change controller to one with a filter on the class.
		setupController(new TestControllerClassMetaData());
		
		execute();
		Assert.same(['executing', 'handler', 'executed'], controller.sequence);
	}

	public function testAttributeAddedOnSuperClass()
	{
		setupController(new TestControllerSuperClassMetaData());
		
		execute();
		Assert.same(['executing', 'handler', 'executed'], controller.sequence);
	}
	
	public function testAttributeOverridingSuperClass()
	{
		setupController(new TestControllerSuperClassOverride());
		
		execute();
		Assert.same(['executingOverride', 'handler', 'executedOverride'], controller.sequence);
	}

	public function testClassWithAuthFailAttribute()
	{
		setupController(new TestControllerAuthFail());
		
		execute();
		Assert.same(['onAuthorization', 'sequenceResultAuthFail'], controller.sequence);
	}
	
	public function testClassWithExceptionHandlerThatFailsToHandleError()
	{
		setupController(new TestControllerNoRealExceptionHandler());
		
		Assert.raises(execute, String);		
		Assert.same(['onException'], controller.sequence);
	}
	
	public function testClassWithExceptionHandlerThatHandlesTheError()
	{
		setupController(new TestControllerWithExceptionHandler());
		
		execute();
		Assert.same(['onException', 'sequenceResultExceptionHandler for ERROR AGAIN'], controller.sequence);
	}
	
	/////////////////////////////////////////////////////////////////
	
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
	
	public function new(){}

	var controller : BaseTestController;
	var context : RequestContext;
	
	public function setup()
	{
		setupController(new TestControllerMetaData());
	}
	
	public function setupController(controller : BaseTestController)
	{
		var context = TestAll.setupController(controller);
		
		this.context = context.requestContext;
		this.controller = cast(context.controller, BaseTestController);
	}
	
	function execute()
	{
		controller.execute(context, new hxevents.Async(function(){}));
	}
}
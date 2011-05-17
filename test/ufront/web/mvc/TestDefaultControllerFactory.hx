package ufront.web.mvc;
import ufront.web.mvc.MvcRouteHandler;
import ufront.web.routing.Route;
import ufront.web.routing.RouteData;
import ufront.web.HttpContextMock;
import thx.error.Error;
import ufront.web.routing.RequestContext;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;

// forces the inclusions of the test controllers
import ufront.web.mvc.test.MockController;
import ufront.web.mvc.MockController;


class TestDefaultControllerFactory
{
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestDefaultControllerFactory());
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
	
	public function new(){}
	
	public function testControllerInst1()
	{
		var builder = new ControllerBuilder();
		builder.packages.add("ufront.web.mvc");
		builder.packages.add("ufront.web.mvc.test");
		var factory = new DefaultControllerFactory(builder, new DefaultDependencyResolver());
		
		// Note that "Controller" is auto-appended.
		var controller = factory.createController(TestAll.getRequestContext(), "MockController");
		Assert.notNull(controller);
		Assert.is(controller, ufront.web.mvc.MockController);
	}
	
	public function testControllerInst2()
	{
		var builder = new ControllerBuilder();
		builder.packages.add("ufront.web.mvc.test");
		builder.packages.add("ufront.web.mvc");
		var factory = new DefaultControllerFactory(builder, new DefaultDependencyResolver());
		
		var controller = factory.createController(TestAll.getRequestContext(), "MockController");
		Assert.notNull(controller);
		Assert.is(controller, ufront.web.mvc.test.MockController);
	}
	
	public function testControllerDisposal1()
	{
		var builder = new ControllerBuilder();
		builder.packages.add("ufront.web.mvc");
		var factory = new DefaultControllerFactory(builder, new DefaultDependencyResolver());
		
		var controller = cast(factory.createController(TestAll.getRequestContext(), "MockController"), ufront.web.mvc.MockController);
		Assert.isFalse(controller.disposed);
		factory.releaseController(controller);
		Assert.isTrue(controller.disposed);		
	}
	
	/**
	 *  test.MockController doesn't have a dispose method
	 */
	public function testControllerDisposal2()
	{
		var builder = new ControllerBuilder();
		builder.packages.add("ufront.web.mvc.test");
		var factory = new DefaultControllerFactory(builder, new DefaultDependencyResolver());
		
		var controller = cast(factory.createController(TestAll.getRequestContext(), "MockController"), ufront.web.mvc.test.MockController);
		Assert.isFalse(controller.disposed);
		factory.releaseController(controller);
		Assert.isFalse(controller.disposed);		
	}
	
	public function testType()
	{
		var builder = new ControllerBuilder();
		builder.packages.add("ufront.web.mvc");
		var factory = new DefaultControllerFactory(builder, new DefaultDependencyResolver());
		
		Assert.raises(function() factory.createController(TestAll.getRequestContext(), "TestDefaultControllerFactory"), Error);
	}
	
	public function testNotFound() 
	{
		var builder = new ControllerBuilder();
		builder.packages.add("ufront.web.mvc");
		var factory = new DefaultControllerFactory(builder, new DefaultDependencyResolver());
		
		Assert.raises(function() factory.createController(TestAll.getRequestContext(), "Fake"), Error);
	}
}
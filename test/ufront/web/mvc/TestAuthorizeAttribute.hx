package ufront.web.mvc;
import ufront.acl.Acl;
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

class TestAuthorizeAttribute
{   
	public function testUser()
	{
		var auth = new AuthorizeAttribute();
		auth.acl = new Acl();
		auth.currentUser = 'franco';
		auth.currentRoles = [];
		auth.roles = [];
		auth.users = ['franco'];
		auth.connect(controller);
		execute();
		var response = cast(controller.controllerContext.response, HttpResponseMock);
		Assert.equals("content", response.getBuffer());
	}
	
	public function testGroup()
	{
		var auth = new AuthorizeAttribute();
		auth.acl = new Acl();    
		auth.currentUser = null;
		auth.currentRoles = ['admin'];
		auth.roles = ['admin'];
		auth.users = [];
		auth.connect(controller);
		execute();
		var response = cast(controller.controllerContext.response, HttpResponseMock);
		Assert.equals("content", response.getBuffer());
	}
	
	public function testFailUser()
	{
		var auth = new AuthorizeAttribute();
		auth.acl = new Acl();
		auth.currentUser = 'drwho';
		auth.currentRoles = [];
		auth.roles = [];
		auth.users = ['franco'];
		auth.connect(controller);
		execute();
		var response = cast(controller.controllerContext.response, HttpResponseMock);
		Assert.notEquals("content", response.getBuffer());
	}
	
	public function testFailGroup()
	{
		var auth = new AuthorizeAttribute();
		auth.acl = new Acl();    
		auth.currentUser = null;
		auth.currentRoles = [];
		auth.roles = ['admin'];
		auth.users = [];
		auth.connect(controller);
		execute();
		var response = cast(controller.controllerContext.response, HttpResponseMock);
		Assert.notEquals("content", response.getBuffer());
	}
	    
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestAuthorizeAttribute());
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
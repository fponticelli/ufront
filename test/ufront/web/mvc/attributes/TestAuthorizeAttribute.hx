package ufront.web.mvc.attributes;
import thx.collection.HashList;
import ufront.acl.Acl;
import ufront.web.error.UnauthorizedError;
import ufront.web.HttpResponseMock;
import thx.error.Error;
import ufront.web.mvc.TestDefaultControllerFactory;
import ufront.web.routing.RequestContext;
import ufront.web.routing.TestUrlRoutingModule;

import ufront.web.mvc.attributes.AuthorizeAttribute;
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

		var authContext = setupContext(auth);
		Assert.isNull(authContext.result);
	}

	public function testGroup()
	{
		var auth = new AuthorizeAttribute();
		auth.acl = new Acl();
		auth.currentUser = null;
		auth.currentRoles = ['admin'];
		auth.roles = ['admin'];
		auth.users = [];

		var authContext = setupContext(auth);
		Assert.isNull(authContext.result);
	}

	public function testFailUser()
	{
		var auth = new AuthorizeAttribute();
		auth.acl = new Acl();
		auth.currentUser = 'drwho';
		auth.currentRoles = [];
		auth.roles = [];
		auth.users = ['franco'];

		var authContext = setupContext(auth);
		Assert.is(authContext.result, HttpUnauthorizedResult);
	}

	public function testFailGroup()
	{
		var auth = new AuthorizeAttribute();
		auth.acl = new Acl();
		auth.currentUser = null;
		auth.currentRoles = [];
		auth.roles = ['admin'];
		auth.users = [];

		var authContext = setupContext(auth);
		Assert.is(authContext.result, HttpUnauthorizedResult);
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
		controller.invoker = new ControllerActionInvoker(new ModelBinderDictionary(), ControllerBuilder.current, new DefaultDependencyResolver());
	}

	function execute()
	{
		controller.execute(context, new hxevents.Async(function(){}));
	}

	function setupContext(auth : AuthorizeAttribute)
	{
		var authContext = new AuthorizationContext(new ControllerContext(controller, context), "index", new HashList<Dynamic>());
		auth.onAuthorization(authContext);

		return authContext;
	}
}
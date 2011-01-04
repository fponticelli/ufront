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

class ControllerTest extends Controller
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
package ufront.web.mvc;
import ufront.web.mvc.TestDefaultControllerFactory;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;

// forces the inclusions of the test controllers
import ufront.web.mvc.test.MockController;
import ufront.web.mvc.MockController; 
import ufront.web.mvc.Controller;


class TestController extends Controller
{      
	var expected : { id : Int, number : Null<Float>, optional : Null<Bool>, arr : Null<Array<Int>> };
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestController());
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
	
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
	
	public function testControllerArguments1()
	{                
		var context = TestAll.getRequestContext(); 
		expected = { id : 1, number : 0.1, optional : true, arr : null };
		context.routeData.data.set("id", "1");
		context.routeData.data.set("number", "0.1");
		context.routeData.data.set("optional", "YES");
		this.execute(context);
	}     
	
	public function testControllerArguments2()
	{                
		var context = TestAll.getRequestContext(); 
		expected = { id : -1, number : null, optional : null, arr : null };
		context.routeData.data.set("id", "-1");             
		this.execute(context);
	}
	
	public function testControllerArguments3()
	{                
		var context = TestAll.getRequestContext(); 
		expected = { id : -1, number : null, optional : null, arr : [2,1,0] };
		context.routeData.data.set("id", "-1");
		context.routeData.data.set("arr", "2,1,0");             
		this.execute(context);
	}
}
package ufront.web.mvc;                           
import ufront.web.mvc.ControllerContext;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;

import ufront.web.mvc.test.MockController;
import ufront.web.mvc.MockController; 
import ufront.web.mvc.Controller;    

import ufront.web.mvc.ViewResult;


class TestViewResult
{      
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestViewResult());
	}

	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
	
	public function new(){}


	static public function createControllerContext()
	{
		return new ControllerContext(
			null, 
			TestAll.getRequestContext());
	}
}
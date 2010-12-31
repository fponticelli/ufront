package ufront.web;

import utest.Runner;
import utest.ui.Report;
import ufront.web.EmptyUploadHandler;
import ufront.web.SaveToDirectoryUploadHandler;

class TestAll
{
	public static function addTests(runner : Runner)
	{
		TestHttpApplication.addTests(runner);
		TestHttpCookie.addTests(runner);
		TestHttpResponse.addTests(runner);
		ufront.web.mvc.TestAll.addTests(runner);
		ufront.web.routing.TestAll.addTests(runner);
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
}
package ufront.web.mvc;

import utest.Runner;
import utest.ui.Report;

class TestAll
{
	public static function addTests(runner : Runner)
	{
		TestDefaultControllerFactory.addTests(runner);
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
}
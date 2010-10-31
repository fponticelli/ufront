package ufront;

import utest.Runner;
import utest.ui.Report;

class TestAll
{
	public static function addTests(runner : Runner)
	{   
		ufront.acl.TestAll.addTests(runner);             
		ufront.auth.TestAll.addTests(runner);
		ufront.web.TestAll.addTests(runner);
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
}
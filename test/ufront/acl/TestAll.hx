package ufront.acl;

import utest.Runner;
import utest.ui.Report;

import ufront.acl.Acl;

class TestAll
{
	public static function addTests(runner : Runner)
	{   
		TestAcl.addTests(runner);
		TestRegistry.addTests(runner);
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
}
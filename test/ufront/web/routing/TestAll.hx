package ufront.web.routing;

import utest.Runner;
import utest.ui.Report;

class TestAll
{
	public static function addTests(runner : Runner)
	{
    	TestRoute.addTests(runner);              
		TestRouteParamExtractor.addTests(runner);  
    	TestRouteUriParser.addTests(runner);
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
}
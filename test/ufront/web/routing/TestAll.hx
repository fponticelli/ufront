package ufront.web.routing;

import utest.Runner;
import utest.ui.Report;

import ufront.web.mvc.HtmlViewResult;

class TestAll
{
	public static function addTests(runner : Runner)
	{                        
		TestPatternConstraint.addTests(runner);
    	TestRoute.addTests(runner);              
		TestRouteParamExtractor.addTests(runner);  
    	TestRouteUriParser.addTests(runner);  
    	TestRouteUriGeneration.addTests(runner);
		TestUrlRoutingModule.addTests(runner);
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
}
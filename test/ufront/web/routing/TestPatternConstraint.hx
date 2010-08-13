package ufront.web.routing;

import utest.Runner;
import utest.ui.Report;
import utest.Assert;

class TestPatternConstraint extends BaseTest
{
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestPatternConstraint());
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}

	public function testPattern() 
	{                                        
		var route = createRoute("/{p}", new PatternConstraint("p", "^\\wb\\d\\d$"));
 	
		Assert.isNull(route.getRouteData(createContext("/")));
		Assert.isNull(route.getRouteData(createContext("/a")));
		Assert.isNull(route.getRouteData(createContext("/ab")));
		Assert.isNull(route.getRouteData(createContext("/abc1")));
		Assert.notNull(route.getRouteData(createContext("/ab12")));
		Assert.isNull(route.getRouteData(createContext("/ab123")));
	}
}
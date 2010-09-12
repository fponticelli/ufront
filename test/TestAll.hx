import utest.Runner;
import utest.ui.Report;

class TestAll
{
	public static function addTests(runner : Runner)
	{
		ufront.TestAll.addTests(runner);
	}
	
	public static function main()
	{     
		try {
			var runner = new Runner();
			addTests(runner);
			Report.create(runner);
			runner.run();   
		} catch(e : Dynamic) {
			trace(e);
		}
	}
}
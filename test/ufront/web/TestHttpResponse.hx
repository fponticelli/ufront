/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;

import ufront.web.HttpResponseMock;
import utest.Assert;
import utest.Runner;
import utest.ui.Report;

class TestHttpResponse
{
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestHttpResponse());
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
	
	public function new(){}
	
	public function testResponse()
	{
		var response = new HttpResponseMock();
		
		response.write("hello");
		
		Assert.equals("hello", response.getBuffer());
		
		response.clear();
		Assert.equals("", response.getBuffer());
	}
}
/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;

class TestHttpCookie
{
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestHttpCookie());
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
	
	public function new(){}
	
	public function testDescription()
	{
		var cookie = new HttpCookie("name", "value");
		Assert.equals("name", cookie.name);
		Assert.equals("value", cookie.description());
		
		cookie.expires = Date.fromString("2001-01-01");
		Assert.equals("value; expires=Mon, 01-Jan-2001 00:00:00 GMT", cookie.description());
		
		cookie.domain = "example.com";
		Assert.equals("value; expires=Mon, 01-Jan-2001 00:00:00 GMT; domain=example.com", cookie.description());
		
		cookie.path = "/path";
		Assert.equals("value; expires=Mon, 01-Jan-2001 00:00:00 GMT; domain=example.com; path=/path", cookie.description());
		
		cookie.secure = true;
		Assert.equals("value; expires=Mon, 01-Jan-2001 00:00:00 GMT; domain=example.com; path=/path; secure", cookie.description());
	}
}
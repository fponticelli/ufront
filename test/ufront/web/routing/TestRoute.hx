package ufront.web.routing;
import ufront.web.HttpRequestMock;
import ufront.web.HttpContextMock;
import ufront.web.HttpContext;
import ufront.web.mvc.MvcRouteHandler;

import utest.Runner;
import utest.ui.Report;
import utest.Assert;

class TestRoute extends BaseTest
{
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestRoute());
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}

	public function testRoot() 
	{
		var route = createRoute("/");
		Assert.notNull(route.getRouteData(createContext("/")));
		Assert.isNull(route.getRouteData(createContext("/a")));
		Assert.isNull(route.getRouteData(createContext("/a/b/")));
	}

	public function testFixed() 
	{
		var route = createRoute("/a");
		Assert.isNull(route.getRouteData(createContext("/")));
		Assert.notNull(route.getRouteData(createContext("/a")));
		Assert.isNull(route.getRouteData(createContext("/a/b/")));
	}
	
	public function testFixed1() 
	{
		var route = createRoute("/a/b");
		Assert.isNull(route.getRouteData(createContext("/")));
		Assert.notNull(route.getRouteData(createContext("/a/b")));
		Assert.isNull(route.getRouteData(createContext("/a/b/")));
	}
	
	public function testFixed2() 
	{
		var route = createRoute("/a/b/c/");
		Assert.isNull(route.getRouteData(createContext("/")));
		Assert.notNull(route.getRouteData(createContext("/a/b/c/")));
		Assert.isNull(route.getRouteData(createContext("/a/b/c")));
	}
	
	public function testParam()
	{
		var route = createRoute("/{a}");
		var data = route.getRouteData(createContext("/"));
		Assert.isNull(data);
		
		data = route.getRouteData(createContext("/abc"));
		Assert.notNull(data);
		Assert.equals("abc", data.data.get("a"));
		
		data = route.getRouteData(createContext("/123"));
		Assert.notNull(data);
		Assert.equals("123", data.data.get("a"));
		
		data = route.getRouteData(createContext("/1.23"));
		Assert.notNull(data);
		Assert.equals("1.23", data.data.get("a"));
		
		data = route.getRouteData(createContext("/x/y"));
		Assert.isNull(data);
	}
	
	public function testValues()
	{
		var route = createRoute("/{a}.html");
		var data = route.getRouteData(createContext("/12.html"));
		Assert.equals("12", data.data.get("a"));
		
		data = route.getRouteData(createContext("/1.2.html"));
		Assert.equals("1.2", data.data.get("a"));
		
		data = route.getRouteData(createContext("/xyz.html"));
		Assert.equals("xyz", data.data.get("a"));
		
		data = route.getRouteData(createContext("/"+StringTools.urlEncode("&#$%§'\")!+") + ".html"));
		Assert.equals("&#$%§'\")!+", data.data.get("a"));
		
//		data = route.getRouteData(createContext("/çéã.html"));
//		Assert.equals("çéã", data.data.get("a"));
		
		data = route.getRouteData(createContext("/" + StringTools.urlEncode("çéã¨ïħşΨ") + ".html"));
		Assert.equals("çéã¨ïħşΨ", data.data.get("a"));
	}
	
	public function testManyParams1()
	{
		var route = createRoute("/{a}/{b}/{c}.html");
		var data = route.getRouteData(createContext("/12/ab/ZX.html"));
		Assert.equals("12", data.data.get("a"));
		Assert.equals("ab", data.data.get("b"));
		Assert.equals("ZX", data.data.get("c"));
	}
	
	public function testManyParams2()
	{
		var route = createRoute("/{a}/b/{c}.html");
		var data = route.getRouteData(createContext("/12/b/ZX.html"));
		Assert.equals("12", data.data.get("a"));
		Assert.equals("ZX", data.data.get("c"));
		
		Assert.isNull(route.getRouteData(createContext("/12/ab/ZX.html")));
	}
	
	public function testManyParams3()
	{
		var route = createRoute("/a/b/{c}.html");
		var data = route.getRouteData(createContext("/a/b/ZX.html"));
		Assert.equals("ZX", data.data.get("c"));
	}
	
	public function testManyParams4()
	{
		var route = createRoute("/{a}/b/c.html");
		var data = route.getRouteData(createContext("/12/b/c.html"));
		Assert.equals("12", data.data.get("a"));
	}

	
	public function testOptional1()
	{
		var route = createRoute("/{?a}");
		var data = route.getRouteData(createContext("/a"));
		Assert.equals("a", data.data.get("a"));
		
		var data = route.getRouteData(createContext("/"));
		Assert.isFalse(data.data.exists("a"));
	}
	
	public function testOptional2()
	{
		var route = createRoute("/{?a}f.html");
		var data = route.getRouteData(createContext("/af.html"));
		Assert.equals("a", data.data.get("a"));
		
		var data = route.getRouteData(createContext("/f.html"));
		Assert.isFalse(data.data.exists("a"));
	}
	
	public function testManyOptional1()
	{
		var route = createRoute("/{a}/{b}/{?c}.html");
		var data = route.getRouteData(createContext("/12/ab/ZX.html"));
		Assert.equals("12", data.data.get("a"));
		Assert.equals("ab", data.data.get("b"));
		Assert.equals("ZX", data.data.get("c"));
	}

	public function testManyOptional2()
	{
		var route = createRoute("/{a}/{?b}/{?c}");
		var data = route.getRouteData(createContext("/12/ab/ZX"));
		Assert.equals("12", data.data.get("a"));
		Assert.equals("ab", data.data.get("b"));
		Assert.equals("ZX", data.data.get("c"));
		
		var data = route.getRouteData(createContext("/12/ab"));
		Assert.equals("12", data.data.get("a"));
		Assert.equals("ab", data.data.get("b"));
		Assert.isFalse(data.data.exists("c"));
		
		var data = route.getRouteData(createContext("/12"));
		Assert.equals("12", data.data.get("a"));
		Assert.isFalse(data.data.exists("b"));
		Assert.isFalse(data.data.exists("c"));
	}
	
	public function testManyOptional3()
	{
		var route = createRoute("/{?a}/{?b}/{?c}");
		var data = route.getRouteData(createContext("/12/ab/ZX"));
		Assert.equals("12", data.data.get("a"));
		Assert.equals("ab", data.data.get("b"));
		Assert.equals("ZX", data.data.get("c"));
		
		var data = route.getRouteData(createContext("/12/ab"));
		Assert.equals("12", data.data.get("a"));
		Assert.equals("ab", data.data.get("b"));
		Assert.isFalse(data.data.exists("c"));
		
		var data = route.getRouteData(createContext("/12"));
		Assert.equals("12", data.data.get("a"));
		Assert.isFalse(data.data.exists("b"));
		Assert.isFalse(data.data.exists("c"));
		
		var data = route.getRouteData(createContext("/"));
		Assert.isFalse(data.data.exists("a"));
		Assert.isFalse(data.data.exists("b"));
		Assert.isFalse(data.data.exists("c"));
	}
	
	public function testManyOptional4()
	{
		var route = createRoute("/{?j}/b/{c}");
		var data = route.getRouteData(createContext("/12/b/ZX"));
		Assert.equals("12", data.data.get("j"));
		Assert.equals("ZX", data.data.get("c"));

		var data = route.getRouteData(createContext("/b/ZX"));
		Assert.isNull(data);
	}
	
	public function testManyOptional5()
	{
		var route = createRoute("/{?a}/b/{?c}");
		var data = route.getRouteData(createContext("/12/b/ZX"));
		Assert.equals("12", data.data.get("a"));
		Assert.equals("ZX", data.data.get("c"));
		
		var data = route.getRouteData(createContext("/b/ZX"));
		Assert.isNull(data);
		
		var data = route.getRouteData(createContext("/12/b"));
		Assert.equals("12", data.data.get("a"));
		Assert.isFalse(data.data.exists("c"));

		var data = route.getRouteData(createContext("/b"));
		Assert.isNull(data);
	}
	
	public function testManyOptional6()
	{
		var route = createRoute("/{a}/b/{?c}");
		var data = route.getRouteData(createContext("/12/b/ZX"));
		Assert.equals("12", data.data.get("a"));
		Assert.equals("ZX", data.data.get("c"));
		
		var data = route.getRouteData(createContext("/12/b"));
		Assert.equals("12", data.data.get("a"));
		Assert.isFalse(data.data.exists("c"));
	}
	
	public function testManyOptional7()
	{
		var route = createRoute("/a/b/{?c}");
		var data = route.getRouteData(createContext("/a/b/ZX"));
		Assert.equals("ZX", data.data.get("c"));
		
		var data = route.getRouteData(createContext("/a/b"));
		Assert.isFalse(data.data.exists("c"));
	}
	
	public function testManyOptional8()
	{
		var route = createRoute("/{?a}/b/c");
		var data = route.getRouteData(createContext("/12/b/c"));
		Assert.equals("12", data.data.get("a"));
		
		var data = route.getRouteData(createContext("/b/c"));
		Assert.isNull(data);
	}
	
	public function testRest1()
	{
		var route = createRoute("/{*a}");
		var data = route.getRouteData(createContext("/12/b/c"));
		Assert.equals("12/b/c", data.data.get("a"));
	}
	
	public function testRest2()
	{
		var route = createRoute("/a/{*b}");
		var data = route.getRouteData(createContext("/a/b/c"));
		Assert.equals("b/c", data.data.get("b"));
	}
	
	public function testRest3()
	{
		var route = createRoute("/{a}/{*b}");
		var data = route.getRouteData(createContext("/a/b/c"));
		Assert.equals("a", data.data.get("a"));
		Assert.equals("b/c", data.data.get("b"));
	}
	
	public function testRest4()
	{
		var route = createRoute("/{?a}/{*b}");
		var data = route.getRouteData(createContext("/a/b/c.html"));
		Assert.equals("a", data.data.get("a"));
		Assert.equals("b/c.html", data.data.get("b"));
		
		var data = route.getRouteData(createContext("/b/c.html"));
		Assert.equals("b", data.data.get("a"));
		Assert.equals("c.html", data.data.get("b"));
		
		var data = route.getRouteData(createContext("/c.html"));
		Assert.isNull(data);
	}
	
	public function testOptionalRest1()
	{
		var route = createRoute("/{?*a}");
		var data = route.getRouteData(createContext("/12/b/c.html"));
		Assert.equals("12/b/c.html", data.data.get("a"));
		
		var data = route.getRouteData(createContext("/"));
		Assert.isFalse(data.data.exists("a"));
	}
	
	public function testOptionalRest2()
	{
		var route = createRoute("/a/{?*b}");
		var data = route.getRouteData(createContext("/a/b/c.html"));
		Assert.equals("b/c.html", data.data.get("b"));
		
		var data = route.getRouteData(createContext("/a"));
		Assert.isFalse(data.data.exists("b"));
	}
	
	public function testOptionalRest3()
	{
		var route = createRoute("/{a}/{?*b}");
		var data = route.getRouteData(createContext("/a/b/c.html"));
		Assert.equals("a", data.data.get("a"));
		Assert.equals("b/c.html", data.data.get("b"));
		
		var data = route.getRouteData(createContext("/a/c.html"));
		Assert.equals("a", data.data.get("a"));
		Assert.equals("c.html", data.data.get("b"));
		
		var data = route.getRouteData(createContext("/a/c"));
		Assert.equals("a", data.data.get("a"));
		Assert.equals("c", data.data.get("b"));
	}
	
	public function testOptionalRest4()
	{
		var route = createRoute("/{?a}/{?*b}");
		var data = route.getRouteData(createContext("/a/b/c.html"));
		Assert.equals("a", data.data.get("a"));
		Assert.equals("b/c.html", data.data.get("b"));
		
		var data = route.getRouteData(createContext("/b/c.html"));
		Assert.equals("b", data.data.get("a"));
		Assert.equals("c.html", data.data.get("b"));
		
		var data = route.getRouteData(createContext("/c.html"));
		Assert.isFalse(data.data.exists("b"));
		Assert.equals("c.html", data.data.get("a"));
		
		var data = route.getRouteData(createContext("/"));
		Assert.isFalse(data.data.exists("a"));
		Assert.isFalse(data.data.exists("b"));
	}
}
package ufront.web.routing;
import haxe.PosInfos;
using DynamicsT;
import thx.collection.Set;
import utest.Runner;
import utest.ui.Report;
import utest.Assert;
import haxe.ds.StringMap;

class TestRouteParamExtractor
{
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestRouteParamExtractor());
	}

	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}

	public function new(){}

	function assert(expected : Dynamic<String>, result : StringMap<String>, ?pos : PosInfos)
	{
		Assert.same(expected.toHash(), result, pos);
	}

	public function testRoot()
	{
		var e = extractor("/");
		assert({}, e.extract("/"));
		Assert.isNull(e.extract("/a"));
		Assert.isNull(e.extract("/a/b/"));
	}

	public function testFixed()
	{
		var e = extractor("/a");
		Assert.isNull(e.extract("/"));
		assert({}, e.extract("/a"));
		Assert.isNull(e.extract("/a/b/"));
	}

	public function testFixed1()
	{
		var e = extractor("/a/b");
		Assert.isNull(e.extract("/"));
		assert({}, e.extract("/a/b"));
		Assert.isNull(e.extract("/a/b/"));
	}

	public function testFixed2()
	{
		var e = extractor("/a/b/c/");
		Assert.isNull(e.extract("/"));
		assert({}, e.extract("/a/b/c/"));
		Assert.isNull(e.extract("/a/b/c"));
	}

	public function testParam()
	{
		var e = extractor("/{a}");
		Assert.isNull(e.extract("/"));

		assert({a : "abc"}, e.extract("/abc"));
		assert({a : "123"}, e.extract("/123"));
		assert({a :"1.23"}, e.extract("/1.23"));

		Assert.isNull(e.extract("/x/y"));
	}

	public function testValues()
	{
		var e = extractor("/{a}.html");
		assert({a : "12"}, e.extract("/12.html"));
		assert({a : "1.2"}, e.extract("/1.2.html"));
		assert({a : "xyz"}, e.extract("/xyz.html"));

		assert({a : "&#$%§'\")!+"}, e.extract("/"+StringTools.urlEncode("&#$%§'\")!+") + ".html"));

		assert({a : "çéã"}, e.extract("/çéã.html"));
		assert({a : "çéã¨ïħşΨ"}, e.extract("/" + StringTools.urlEncode("çéã¨ïħşΨ") + ".html"));
	}

	public function testManyParams1()
	{
		var e = extractor("/{a}/{b}/{c}.html");
		assert({a : "12", b : "ab", c : "ZX"}, e.extract("/12/ab/ZX.html"));
	}

	public function testManyParams2()
	{
		var e = extractor("/{a}/b/{c}.html");
		assert({a : "12", c : "ZX"}, e.extract("/12/b/ZX.html"));
		Assert.isNull(e.extract("/12/ab/ZX.html"));
	}

	public function testManyParams3()
	{
		var e = extractor("/a/b/{c}.html");
		assert({c : "ZX"}, e.extract("/a/b/ZX.html"));
	}

	public function testManyParams4()
	{
		var e = extractor("/{a}/b/c.html");
		assert({a : "12"}, e.extract("/12/b/c.html"));
	}


	public function testOptional1()
	{
		var e = extractor("/{?a}");
		assert({a : "a"}, e.extract("/a"));
		assert({}, e.extract("/"));
	}

	public function testOptional2()
	{
		var e = extractor("/{?a}f.html");
		assert({a : "a"}, e.extract("/af.html"));
    	assert({}, e.extract("/f.html"));
	}

	public function testManyOptional1()
	{
		var e = extractor("/{a}/{b}/{?c}.html");
		assert({a : "12", b : "ab", c : "ZX"}, e.extract("/12/ab/ZX.html"));
		// .html makes the last segment mandatory so there is no match
		Assert.isNull(e.extract("/12/ab.html"));
		assert({a : "12", b : "ab"}, e.extract("/12/ab/.html"));
	}

	public function testManyOptional2()
	{
		var e = extractor("/{a}/{?b}/{?c}.html");
		assert({a : "12", b : "ab", c : "ZX"}, e.extract("/12/ab/ZX.html"));
		Assert.isNull(e.extract("/12/ab.html"));
		Assert.isNull(e.extract("/12/.html"));
	}

	public function testManyOptional3()
	{
		var e = extractor("/{a}/b/{?c}.html");
		assert({a : "12", c : "ZX"}, e.extract("/12/b/ZX.html"));
		Assert.isNull(e.extract("/12/.html"));
		assert({a : "12"}, e.extract("/12/b/.html"));
	}

	public function testManyOptional4()
	{
		var e = extractor("/{?a}/b/{?c}.html");
		var data = e.extract("/12/b/ZX.html");
		assert({a : "12", c : "ZX"}, e.extract("/12/b/ZX.html"));
		Assert.isNull(e.extract("/b/ZX.html"));
		assert({a : "12"}, e.extract("/12/b/.html"));
		Assert.isNull(e.extract("/12/b.html"));
 	    Assert.isNull(e.extract("/b.html"));
	}


	public function testRest1()
	{
		var e = extractor("/{*a}");
		assert({a : "12/b/c.html"}, e.extract("/12/b/c.html"));
	}

	public function testRest2()
	{
		var e = extractor("/a/{*b}");
		assert({b : "b/c.html"}, e.extract("/a/b/c.html"));
	}

	public function testRest3()
	{
		var e = extractor("/{a}/{*b}");
		assert({a : "a", b : "b/c.html"}, e.extract("/a/b/c.html"));
	}

	public function testRest4()
	{
		var e = extractor("/{?a}/{*b}");
    	assert({a : "a", b : "b/c.html"}, e.extract("/a/b/c.html"));
    	assert({a : "b", b : "c.html"}, e.extract("/b/c.html"));
		Assert.isNull(e.extract("/c.html"));
	}

	public function testOptionalRest1()
	{
		var e = extractor("/{?*a}");
		assert({a : "12/b/c.html"}, e.extract("/12/b/c.html"));
		assert({}, e.extract("/"));
	}

	public function testOptionalRest2()
	{
		var e = extractor("/a/{?*b}");
		assert({b : "b/c.html"}, e.extract("/a/b/c.html"));
		assert({}, e.extract("/a"));
	}

	public function testOptionalRest3()
	{
		var e = extractor("/{a}/{?*b}");
		assert({a : "a", b : "b/c.html"}, e.extract("/a/b/c.html"));
		assert({a : "a", b : "c.html"}, e.extract("/a/c.html"));
		assert({a : "a", b : "c"}, e.extract("/a/c"));
	}

	public function testOptionalRest4()
	{
		var e = extractor("/{?a}/{?*b}");
		assert({a : "a", b : "b/c.html"}, e.extract("/a/b/c.html"));
		assert({a : "b", b : "c.html"}, e.extract("/b/c.html"));
		assert({a : "c.html"}, e.extract("/c.html"));
		assert({}, e.extract("/"));
	}

	public function extractor(url : String, ?optionals : Set<String>)
	{
		if(null == optionals)
			optionals = new Set();
		var parser = new RouteUriParser();
		var ast = parser.parse(url, optionals);
		return new RouteParamExtractor(ast);
	}
}
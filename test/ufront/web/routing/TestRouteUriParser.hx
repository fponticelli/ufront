package ufront.web.routing;
import haxe.PosInfos;
import thx.collection.Set;
import ufront.web.routing.RouteUriParser;

import utest.Runner;
import utest.ui.Report;
import utest.Assert;

class TestRouteUriParser
{
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestRouteUriParser());
	}

	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}

	public function new(){}

	var parser : RouteUriParser;
	var set : Set<String>;

	public function setup()
	{
	    parser = new RouteUriParser();
		set = new Set();
	}

	public function testNoParam()
	{
 		assertOne(false, false, [UPConst("nothing")], "/nothing");
   		Assert.same([
 			{optional : false,  rest : false, parts : [UPConst("nothing")]},
 			{optional : false,  rest : false, parts : [UPConst("some_thing.html")]}],
 			parser.parse("/nothing/some_thing.html", set));
	}

	public function testParam()
	{
		assertOne(false, false, [UPParam("p1")], "/{p1}");
		assertOne(false, false, [UPParam("p1"), UPParam("p2")], "/{p1}{p2}");
  		assertOne(false, false, [UPParam("p1"), UPConst("_"), UPParam("p2")], "/{p1}_{p2}");
		assertOne(false, false, [UPParam("p1"), UPConst(".html")], "/{p1}.html");
		assertOne(false, false, [UPConst("a"), UPParam("p1"), UPConst("b")], "/a{p1}b");
	}

	public function testComplex()
	{
		var parts = parser.parse("/a{?p1}b{?p2}c{?p3?}d/{p4?}e{p5}/{?p6}.{?*r?}x", set);
		Assert.same([
			{optional : true,  rest : false, parts : [UPOptLParam("p1", "a"), UPOptLParam("p2", "b"), UPOptBParam("p3", "c", "d")]},
			{optional : false, rest : false, parts : [UPOptRParam("p4", "e"), UPParam("p5")]},
			{optional : true,  rest : true, parts : [UPOptParam("p6"), UPOptBRest("r", ".", "x")]}
			],
			parts);
	}

	public function testOptionalParam()
	{
		assertOne(true,  false, [UPOptParam("a")], "/{?a}");
		assertOne(true,  false, [UPOptParam("a")], "/{a?}");
		assertOne(true,  false, [UPOptLParam("b", "a")], "/a{?b}");
		assertOne(false, false, [UPConst("a"), UPOptParam("b")], "/a{b?}");
		assertOne(true,  false, [UPOptRParam("a", "b")], "/{a?}b");
		assertOne(true,  false, [UPOptBParam("b", "a", "c")], "/a{?b?}c");
		assertOne(false, false, [UPConst("a"), UPParam("p1"), UPOptLParam("p2", "_")], "/a{p1}_{?p2}");
		assertOne(true,  false, [UPOptBParam("p1", "a", "_"), UPOptParam("p2")], "/a{?p1?}_{?p2}");
	}

	public function testRestParam()
	{
		assertOne(true,  true, [UPOptRest("a")], "/{?*a}");
		assertOne(true,  true, [UPOptLRest("b", "a")], "/a{?*b}");
		assertOne(false, true, [UPRest("a")], "/{*a}");
		assertOne(false, true, [UPConst("a"), UPRest("b"), UPConst("c/d")], "/a{*b}c/d");
		assertOne(false, true, [UPConst("a"), UPOptRRest("b", "c/d")], "/a{*b?}c/d");
		assertOne(false, true, [UPConst("a"), UPOptRest("b"), UPConst("c/d")], "/a{$*b}c/d");
		assertOne(true,  true, [UPOptBRest("b", "a", "c/d")], "/a{?*b?}c/d");
		assertOne(false, true, [UPOptLRest("b", "a"), UPConst("c/d")], "/a{?*b}c/d");
   	}

    public function testImplicitOptional()
 	{
		set.add("a");
    	assertOne(true, false, [UPOptParam("a")], "/{a}");
    	assertOne(true, true,  [UPOptRest("a")], "/{*a}");
    }

	public function testOptionalRestLeftWithRightConst()
	{
	   Assert.same([
	  	{optional : false, rest : false, parts : [UPConst("a")]},
  		{optional : false, rest : true,  parts : [UPOptLRest("b", "x"), UPConst("y")]}],
		parser.parse("/a/x{?*b}y", set));
	}

	public function testInvalidSequence()
	{
		var p = parser;
		var s = set;
		var invalids = ["/{a b}", "/{#}", "/{}", "/{a*}", "/{*?a}", "/{??a}", "/{**a}", "/{*a}/{*b}", "/{a}/{a}"];
		for(invalid in invalids)
		{
			Assert.raises(function() p.parse(invalid, s), null, "the sequence '" + invalid + "' should be invalid");
		}
	}

	function assertOne(optional : Bool, rest : Bool, parts : Array<UriPart>, uri : String, ?pos : PosInfos)
	{
		var m = [{optional : optional,  rest : rest, parts : parts}];
		var t = parser.parse(uri, set);
		Assert.same(
			m, t, true,
			"expected \n" + dumpSegments(m) + "\n but is \n" + dumpSegments(t) + "\n for \n" + uri,
			pos);
	}

	function dumpSegment(segment : UriSegment)
	{
		var s = "{";
		s += "optional: " + Std.string(segment.optional) + ", rest: " + Std.string(segment.rest) + ", parts: [";
		var f = true;
		for(part in segment.parts)
		{
			if(f)
				f = false;
			else
				s += ", ";
	 		s += Std.string(part);
		}
		s += "]}";
		return s;
	}

	function dumpSegments(segments : UriSegments)
	{
		var s = "[";
		var f = true;
		for(segment in segments)
		{
			if(f)
				f = false;
			else
				s += ", ";
			s += dumpSegment(segment);
		}
		s += "]";
		return s;
	}
}
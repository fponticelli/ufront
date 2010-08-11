package ufront.web.routing;
import udo.collections.Set;
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
	
	public function new();
	
	var parser : RouteUriParser;
	var set : Set<String>;
	
	public function setup()
	{
	    parser = new RouteUriParser();
		set = new Set();
	}
	      
	public function testNoParam() 
	{   
 		Assert.same(
 			o(false, [UPConst("nothing")]),
 			parser.parse("/nothing", set));  
   		Assert.same({
			mandatory : [],
			segments : [
 			c(false, [UPConst("nothing")]), 
 			c(false, [UPConst("some_thing.html")])]}, parser.parse("/nothing/some_thing.html", set));  
	}
   
	public function testParam() 
	{
		Assert.same(o(false, [UPParam("p1")]), parser.parse("/{p1}", set));
		Assert.same(o(false, [UPParam("p1"), UPParam("p2")]), parser.parse("/{p1}{p2}", set)); 
  		Assert.same(o(false, [UPParam("p1"), UPConst("_"), UPParam("p2")]), parser.parse("/{p1}_{p2}", set)); 
		Assert.same(o(false, [UPParam("p1"), UPConst(".html")]), parser.parse("/{p1}.html", set));   
		Assert.same(o(false, [UPConst("a"), UPParam("p1"), UPConst("b")]), parser.parse("/a{p1}b", set));   
	}                 
	
	public function testComplex()
	{
		Assert.same({
			mandatory : [],
			segments :[           
			c(true,  [UPOptLParam("p1", "a"), UPOptLParam("p2", "b"), UPOptBParam("p3", "c", "d")]),
			c(false, [UPOptRParam("p4", "e"), UPParam("p5")]),
			c(true,  [UPOptParam("p6"), UPOptBRest("r", ".", "x")])
			]},
			parser.parse("/a{?p1}b{?p2}c{?p3?}d/{p4?}e{p5}/{?p6}.{?*r?}x", set));
	}   
	
	public function testOptionalParam() 
	{                                            
		Assert.same(o(true,  [UPOptParam("a")]), parser.parse("/{?a}", set));  
		Assert.same(o(true,  [UPOptParam("a")]), parser.parse("/{a?}", set));     
		Assert.same(o(true,  [UPOptLParam("b", "a")]), parser.parse("/a{?b}", set)); 
		Assert.same(o(false, [UPConst("a"), UPOptParam("b")]), parser.parse("/a{b?}", set));    
		Assert.same(o(true,  [UPOptRParam("a", "b")]), parser.parse("/{a?}b", set));    
		Assert.same(o(true,  [UPOptBParam("b", "a", "c")]), parser.parse("/a{?b?}c", set)); 
		Assert.same(o(false, [UPConst("a"), UPParam("p1"), UPOptLParam("p2", "_")]), parser.parse("/a{p1}_{?p2}", set));   
		Assert.same(o(true,  [UPOptBParam("p1", "a", "_"), UPOptParam("p2")]), parser.parse("/a{?p1?}_{?p2}", set));   
	}                                            
	                                             
	public function testRestParam()              
	{                                            
		Assert.same(o(true,  [UPOptRest("a")]), parser.parse("/{?*a}", set));  
		Assert.same(o(true,  [UPOptLRest("b", "a")]), parser.parse("/a{?*b}", set));  
		Assert.same(o(false, [UPRest("a")]), parser.parse("/{*a}", set));
		Assert.same({
			mandatory : [],
			segments :[
			c(false, [UPConst("a"), UPRest("b"), UPConst("c")]),
			c(false, [UPConst("d")])]},
			parser.parse("/a{*b}c/d", set));
   	}  

    public function testImplicitOptional()
 	{                   
		set.add("a");
    	Assert.same(o(true, [UPOptParam("a")]), parser.parse("/{a}", set));
    	Assert.same(o(true, [UPOptRest("a")]), parser.parse("/{*a}", set));
    }
                                          
	
	public function testInvalidSequence()
	{         
		var p = parser;     
		var s = set;
		var invalids = ["/{a b}", "/{#}", "/{}", "/{a*}", "/{*?a}", "/{??a}", "/{**a}", "/{*a}/{*b}", "/{a}/{a}"];
		for(invalid in invalids)
		{
			Assert.raises(function() p.parse(invalid, s), Dynamic, "the sequence '" + invalid + "' should be invalid");
		}
	} 
	
	function c(optional : Bool, parts : Array<UriPart>)
	{
		return {
			optional : optional,
			parts : parts
		};
	}
	
	function o(optional : Bool, parts : Array<UriPart>, ?mandatory : Array<String>)
	{                                                                             
		if(null == mandatory)
			mandatory = [];
		return { mandatory : mandatory, segments : [c(optional, parts)]};
	}        
}
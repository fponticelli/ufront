package ufront.web.routing;
import haxe.PosInfos;
using Hashes;
using DynamicsT;
import utest.Runner;
import utest.ui.Report;
import utest.Assert;
import haxe.ds.StringMap;

class TestRouteUriGeneration extends BaseTest
{
	public static function addTests(runner : Runner)
	{
		runner.addCase(new TestRouteUriGeneration());
	}
	
	public static function main()
	{
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
	
	public static inline function here(?pos : haxe.PosInfos) return pos;

	public function testGeneration() 
	{   
		var tests = [
			{ uri : "/a",               test : [{ path : "/a",         pos : here()}]},
			{ uri : "/{a}",             test : [{ path : "/b",         pos : here()}]}, 
			{ uri : "/{a}/{b}",         test : [{ path : "/b/123",     pos : here()}, 
										        { path : "/12.5/12.5", pos : here()}]}, 
			{ uri : "/b{?a}/{b}",       test : [{ path : "/bb/123",    pos : here()}, 
			 							        { path : "/c",         pos : here()}]}, 
			{ uri : "/{?a}/{?b}",       test : [{ path : "/b/123",     pos : here()},
			 							        { path : "/x",    	   pos : here()},
										        { path : "/",     	   pos : here()}]}, 
			{ uri : "/{?a}/x{?b}",      test : [{ path : "/b/x123",    pos : here()},
		 					     	            { path : "/x",    	   pos : here()}]},  
			{ uri : "/z{?a}/x{?b}y",    test : [{ path : "/zb/x123y",  pos : here()},
			 							        { path : "/y",    	   pos : here()},
										        { path : "/xay",       pos : here()}]},   
	 		{ uri : "/z{?a}w/x{?b}y",   test : [{ path : "/zbw/x123y", pos : here()},
	 		 							        { path : "/w/y",       pos : here()},
	 									        { path : "/w/xay",     pos : here()}]},
            { uri : "/z{a?}w/x{b?}y",   test : [{ path : "/zbw/x123y", pos : here()},
								 		 	    { path : "/z/x",       pos : here()},  
								 			    { path : "/z1w/x",     pos : here()},  
								 			    { path : "/z/xay",     pos : here()}]},  
			{ uri : "/z{?a}w/x{?b}y",   test : [{ path : "/zbw/x123y", pos : here()},
										        { path : "/w/y",       pos : here()},
									 		    { path : "/w/xay",     pos : here()}]},
			{ uri : "/z{?a?}w/x{?b?}y", test : [{ path : "/zbw/x123y", pos : here()},
								 		 	    { path : "/x1y",       pos : here()},  
								 			    { path : "/z1w",       pos : here()}]}, 
		    { uri : "/z{$a}w",          test : [{ path : "/zbw",       pos : here()},
		    						            { path : "/zw",        pos : here()}]},  
		    { uri : "/a/x{*b}y",        test : [{ path : "/a/x/y/y",   pos : here()},
							 		            { path : "/a/xwy",     pos : here()},  
							 			        { path : "/a/x/s/n.y", pos : here()}]}, 
			{ uri : "/a/x{?*b?}y",      test : [{ path : "/a/x/y/y",   pos : here()},
							 		            { path : "/a",         pos : here()}]},  
		   	{ uri : "/a/x{?*b}y",       test : [{ path : "/a/xy/ay",   pos : here()},
							 		 	        { path : "/a/y",       pos : here()}]}, 
			{ uri : "/a/x{*b?}y",       test : [{ path : "/a/x/y/y",   pos : here()},
							 		 	        { path : "/a/x",       pos : here()}]},
		];            
		for(test in tests)
			for(t in test.test)
	   			assertGen(test.uri, t.path, t.pos);
	}   
	
	function assertGen(uri : String, src : String, pos : PosInfos, ?data : Dynamic<String>)
	{
		var route = createRoute(uri);
		var context = createContext(src); // the param is not used so it doesn't matter
		if(null == data)
			data = {}; 
	   	var params = data.toHash();
		var routeData = route.getRouteData(context);
		if(routeData == null)                                                           
		{
			Assert.fail("unable to create a route for '" + uri + "' from '" + src + "';" + untyped route.getAst(), pos);  
			return;
		}
		params = routeData.data.copyTo(params);
		Assert.equals(src, route.getPath(context, params));
	}
}
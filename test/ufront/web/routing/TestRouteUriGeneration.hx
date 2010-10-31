package ufront.web.routing;
import haxe.PosInfos;
import thx.collections.UHash;
using thx.collections.UHash;
import utest.Runner;
import utest.ui.Report;
import utest.Assert;

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
	
	public static inline function _here(?pos : haxe.PosInfos) return pos

	public function testGeneration() 
	{   
		var tests = [
			{ uri : "/a",               test : [{ path : "/a",         pos : _here()}]},
			{ uri : "/{a}",             test : [{ path : "/b",         pos : _here()}]}, 
			{ uri : "/{a}/{b}",         test : [{ path : "/b/123",     pos : _here()}, 
										        { path : "/12.5/12.5", pos : _here()}]}, 
			{ uri : "/b{?a}/{b}",       test : [{ path : "/bb/123",    pos : _here()}, 
			 							        { path : "/c",         pos : _here()}]}, 
			{ uri : "/{?a}/{?b}",       test : [{ path : "/b/123",     pos : _here()},
			 							        { path : "/x",    	   pos : _here()},
										        { path : "/",     	   pos : _here()}]}, 
			{ uri : "/{?a}/x{?b}",      test : [{ path : "/b/x123",    pos : _here()},
		 					     	            { path : "/x",    	   pos : _here()}]},  
			{ uri : "/z{?a}/x{?b}y",    test : [{ path : "/zb/x123y",  pos : _here()},
			 							        { path : "/y",    	   pos : _here()},
										        { path : "/xay",       pos : _here()}]},   
	 		{ uri : "/z{?a}w/x{?b}y",   test : [{ path : "/zbw/x123y", pos : _here()},
	 		 							        { path : "/w/y",       pos : _here()},
	 									        { path : "/w/xay",     pos : _here()}]},
            { uri : "/z{a?}w/x{b?}y",   test : [{ path : "/zbw/x123y", pos : _here()},
								 		 	    { path : "/z/x",       pos : _here()},  
								 			    { path : "/z1w/x",     pos : _here()},  
								 			    { path : "/z/xay",     pos : _here()}]},  
			{ uri : "/z{?a}w/x{?b}y",   test : [{ path : "/zbw/x123y", pos : _here()},
										        { path : "/w/y",       pos : _here()},
									 		    { path : "/w/xay",     pos : _here()}]},
			{ uri : "/z{?a?}w/x{?b?}y", test : [{ path : "/zbw/x123y", pos : _here()},
								 		 	    { path : "/x1y",       pos : _here()},  
								 			    { path : "/z1w",       pos : _here()}]}, 
		    { uri : "/z{$a}w",          test : [{ path : "/zbw",       pos : _here()},
		    						            { path : "/zw",        pos : _here()}]},  
		    { uri : "/a/x{*b}y",        test : [{ path : "/a/x/y/y",   pos : _here()},
							 		            { path : "/a/xwy",     pos : _here()},  
							 			        { path : "/a/x/s/n.y", pos : _here()}]}, 
			{ uri : "/a/x{?*b?}y",      test : [{ path : "/a/x/y/y",   pos : _here()},
							 		            { path : "/a",         pos : _here()}]},  
		   	{ uri : "/a/x{?*b}y",       test : [{ path : "/a/xy/ay",   pos : _here()},
							 		 	        { path : "/a/y",       pos : _here()}]}, 
			{ uri : "/a/x{*b?}y",       test : [{ path : "/a/x/y/y",   pos : _here()},
							 		 	        { path : "/a/x",       pos : _here()}]},
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
	   	var params = UHash.createHash(data);
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
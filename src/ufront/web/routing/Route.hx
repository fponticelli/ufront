/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
import udo.collections.UHash;
import ufront.web.routing.RouteParamExtractor;
import ufront.web.routing.RouteData; 
import ufront.web.routing.RouteDirection;
using udo.collections.UHash;
import uform.util.Error;
import ufront.web.HttpContext;
import udo.error.NullArgument;
import ufront.web.routing.RouteUriParser;
using StringTools;       

class Route extends RouteBase
{	
	static var parser = new RouteUriParser();  
	
	public var url(default, null) : String;
	public var handler(default, null) : IRouteHandler;
	public var defaults(default, null) : Hash<String>;  
	public var constraints(default, null) : Array<IRouteConstraint>;      
	      
	var extractor : RouteParamExtractor;    
	var builder : RouteUriBuilder;
	/**
	 *
	 * @todo add package prioritizing for controller matching
	 * @param	url
	 * @param	handler
	 * @param	?defaults
	 * @param	?constraints
	 */
	public function new(url : String, handler : IRouteHandler, ?defaults : Hash<String>, ?constraints : Array<IRouteConstraint>)
	{
		NullArgument.throwIfNull(url, "url");
		if (!url.startsWith("/"))
			throw new Error("invalid route url '{0}'; url must begin with '/'", url);
		this.url = url;
		NullArgument.throwIfNull(handler, "handler");
		this.handler = handler;
		if (null == defaults)
			this.defaults = new Hash();
		else
			this.defaults = defaults;
		if (null == constraints)
			this.constraints = [];
		else
			this.constraints = constraints;
	}
	
	var _ast : UriSegments;
	function getAst()
	{
		if(null == _ast)
			_ast = parser.parse(url, defaults.setOfKeys());
		return _ast;
	}
	
	override function getRouteData(httpContext : HttpContext) : RouteData 
	{
		var requesturi = httpContext.requestUri;
		if(!requesturi.startsWith("/"))
			throw new Error("invalid requestUri '{0}'", requesturi);
		
		if(null == extractor)
		{   
			extractor = new RouteParamExtractor(getAst());
		}
		
		var params = extractor.extract(requesturi);
		if(null == params)
			return null;
	    else {                                                                    
			if(!processConstraints(httpContext, params, RouteDirection.IncomingRequest))
				return null;
			else
				return new RouteData(this, handler, params.copyTo(defaults.clone()));
		}  
	}   
	
	override function getPath(httpContext : HttpContext, data : Hash<String>)
	{                
	    var params = null == data ? new Hash() : data;
		if(!processConstraints(httpContext, data, RouteDirection.UrlGeneration))
			return null;
		else {
			if(null == builder)
			{   
				builder = new RouteUriBuilder(getAst());
			}
			return builder.build(params);
		}
	}
  
	function processConstraints(httpContext : HttpContext, params : Hash<String>, direction : RouteDirection)
	{
		for(constraint in constraints)
			if(!constraint.match(httpContext, this, params, direction))
				return false;
		return true;
	}
	
	public function toString()
	{
		return "{ url : " + url + ", handler : " + handler + ", defaults: " + defaults + ", constraints : " + constraints + " }";
	}
}
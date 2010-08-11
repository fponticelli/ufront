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
using StringTools;       

class Route extends RouteBase
{	
	static var parser = new RouteUriParser();
	
	public var url(default, null) : String;
	public var handler(default, null) : IRouteHandler;
	public var params(default, null) : Hash<String>;  
	public var defaults(default, null) : Hash<String>;  
	public var constraints(default, null) : Array<IRouteConstraint>;
	      
	var extractor : RouteParamExtractor;
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
	
	override function getRouteData(httpContext : HttpContext) : RouteData 
	{
		var requesturi = httpContext.requestUri;
		if(!requesturi.startsWith("/"))
			throw new Error("invalid requestUri '{0}'", requesturi);
		
		if(null == extractor)
		{   
			var ast = parser.parse(url, defaults.setOfKeys());
			extractor = new RouteParamExtractor(ast);
			
		}
		
		params = extractor.extract(requesturi);
		if(null == params)
			return null;
	    else {                                                                    
			if(!processConstraints(httpContext, RouteDirection.IncomingRequest))
				return null;
			else
				return new RouteData(this, handler, params.copyTo(defaults.clone()));
		}  
	}
  
	public function processConstraints(httpContext : HttpContext, direction : RouteDirection)
	{
		for(constraint in constraints)
			if(!constraint.match(httpContext, this, direction))
				return false;
		return true;
	}
	
	public function toString()
	{
		return "{ url : " + url + ", handler : " + handler + ", params: " + params  + ", defaults: " + defaults + ", constraints : " + constraints + " }";
	}
}
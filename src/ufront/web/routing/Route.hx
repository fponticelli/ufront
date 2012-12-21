/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
import ufront.web.UrlDirection;
import ufront.web.routing.RouteParamExtractor;
import ufront.web.routing.RouteData;
import ufront.web.UrlDirection;
using Hashes;
import thx.error.Error;
import ufront.web.HttpContext;
import thx.error.NullArgument;
import ufront.web.routing.RouteUriParser;
using StringTools;

class Route extends RouteBase
{
	public static var parser = new RouteUriParser();

	public var url(getUrl, null) : String;
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
		NullArgument.throwIfNull(url);
		if (!url.startsWith("/"))
			throw new Error("invalid route url '{0}'; url must begin with '/'", url);
		this.url = url;
		NullArgument.throwIfNull(handler);
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

	//added public to match visibility of ROuteBase, the compiler complains on that!
	public override function getRouteData(httpContext : HttpContext) : RouteData
	{
		var requesturi = httpContext.getRequestUri();
		if(!requesturi.startsWith("/"))
			throw new Error("invalid requestUri '{0}'", requesturi);

		if(null == extractor)
		{
			extractor = new RouteParamExtractor(getAst());
		}

		var params = extractor.extract(requesturi);
		if(null == params)
			return null;
	    else
		{
			var r = httpContext.request;
		    params = params.copyTo(r.query.copyTo(r.post.copyTo(defaults.clone())));
			if(!processConstraints(httpContext, params, UrlDirection.IncomingUrlRequest))
				return null;
			else
				return new RouteData(this, handler, params);
		}
	}

	//added public to match visibility of ROuteBase, the compiler complains on that!
	public override function getPath(httpContext : HttpContext, data : Hash<String>)
	{
	    var params = null == data ? new Hash() : data;
		if(!processConstraints(httpContext, params, UrlDirection.UrlGeneration))
			return null;
		else {
			if(null == builder)
			{
				builder = new RouteUriBuilder(getAst());
			}
			// drops defaults from data
			for(key in defaults.keys())
			{
				if(data.get(key) == defaults.get(key))
					data.remove(key);
			}

			var url = builder.build(params);
			// if controller/action param is not consumed than this is the wrong route
			if(null == url || params.exists("controller") || params.exists("action"))
			    return null;

			var qs = [];
			for(key in params.keys())
			{
				qs.push(StringTools.urlEncode(key) + "=" + StringTools.urlEncode("" + params.get(key)));
			}
			if(qs.length > 0)
			{
				url += "?" + qs.join("&");
			}
			return httpContext.generateUri(url);
		}
	}

	function getUrl()
	{
		return url;
	}

	function processConstraints(httpContext : HttpContext, params : Hash<String>, direction : UrlDirection)
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
package ufront.web.routing;
import ufront.web.routing.RouteCollection;
import ufront.web.HttpContext;
import ufront.web.mvc.MvcRouteHandler;
import thx.translation.ITranslation;
import thx.error.NullArgument;
import ufront.web.routing.IRouteHandler;
import ufront.web.routing.RouteUriParser;
import haxe.ds.StringMap;
using Hashes;
using DynamicsT;

class LocalizedRoute extends Route
{
	public var translator(default, null) : ITranslation;
	public var currentLanguage : String;
	public var paramName : String;
	public function new(translator : ITranslation, url : String, handler : IRouteHandler, ?defaults : StringMap<String>, ?constraints : Array<IRouteConstraint>)
	{
		super(url, handler, defaults, constraints);
		_asts = new StringMap();
		NullArgument.throwIfNull(translator);
		this.translator = translator;
		currentLanguage = null;
		paramName = "lang";
	}

	override function get_url()
	{
		if(null == currentLanguage)
			return super.get_url();
		else
			// NEED TO CHECK THAT THE UNCOMMENTED LINE IS EQUIVALENT TO THE COMMENTED LINE
			// return translator._(super.get_url(), currentLanguage);
			return translator.singular(super.get_url(), currentLanguage);
	}

	var _asts : StringMap<UriSegments>;
	override function getAst()
	{
		var key = currentLanguage;
		if(null == key)
			key = "";
		var ast = _asts.get(key);
		if(null == ast)
		{
			ast = Route.parser.parse(url, defaults.setOfKeys());
			_asts.set(key, ast);
		}
		return ast;
	}

	override function getRouteData(httpContext : HttpContext) : RouteData
	{
  //  	trace("rule url: " + url + ", request: " + httpContext.request.uri + ", context: " + httpContext.getRequestUri() + ", query params: " + httpContext.request.query);
 //   	trace(httpContext.request.query);
		currentLanguage = httpContext.request.query.get(paramName);
		return super.getRouteData(httpContext);
		/*
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
	    else {
			var r = httpContext.request;
		    params = params.copyTo(r.query.copyTo(r.post.copyTo(defaults.clone())));
			if(!processConstraints(httpContext, params, UrlDirection.IncomingUrlRequest))
				return null;
			else
				return new RouteData(this, handler, params);
		}
		*/
	}

	override function getPath(httpContext : HttpContext, data : StringMap<String>)
	{
		if(!data.exists(paramName))
		{
			var value = httpContext.request.query.get(paramName);
			if(null != value)
				data.set(paramName, value);
		}
		if(data.exists(paramName))
			currentLanguage = data.get(paramName);
		else
			currentLanguage = null;
//		trace(data);

//		currentLanguage = data.get(paramName);
 //   	if(null == currentLanguage)
  //  		currentLanguage = httpContext.request.query.get(paramName);
		return super.getPath(httpContext, data);
		/*
	    var params = null == data ? new StringMap() : data;
		if(!processConstraints(httpContext, data, UrlDirection.UrlGeneration))
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
			// if controller param is not consumed than this is the wrong route
			if(null == url || params.exists("controller"))
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
		*/
	}


	public static function addLocalizedRoute(collection : RouteCollection, translator : ITranslation, uri : String, ?defaults : Dynamic<String>, ?constraints : Array<IRouteConstraint>)
	{
		collection.add(
	   		new LocalizedRoute(
				translator,
		    	uri,
				new MvcRouteHandler(),
				null == defaults ? null : defaults.toHash(),
				constraints));
	}
}
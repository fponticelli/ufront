package ufront.web.mvc.view;
import thx.error.Error;
import ufront.web.mvc.IViewHelper;
import ufront.web.routing.RequestContext;
import ufront.web.routing.Route;
import haxe.ds.StringMap;
using Types;
using Hashes;

/** Contains methods to build URLs for Ufront within an application. */
class UrlHelper implements IViewHelper
{
    public var name(default, null) : String;
	public var requestContext(default, null) : RequestContext;
	public var inst(default, null) : UrlHelperInst;
	public function new(name = "Url", requestContext : RequestContext)
	{
		this.name = name;
		this.requestContext = requestContext;
		this.inst = new UrlHelperInst(requestContext);
	}

	public function register(data : StringMap<Dynamic>)
	{
		data.set(name, inst);
	}
}

class UrlHelperInst
{
	var __req : RequestContext;
	public function new(requestContext : RequestContext)
	{
		__req = requestContext;
	}

	public function base(?uri : String)
	{
		if(null == uri)
			uri = "/";
		return __req.httpContext.generateUri(uri);
	}

	public function current(?params : Dynamic)
	{
		var url = __req.httpContext.getRequestUri();
		if(null != params)
		{
			var qs = [];
			for(field in Reflect.fields(params))
			{
				var value = Reflect.field(params, field);
				qs.push(field + "=" + encode(value));
			}
			if(qs.length > 0)
				url += (url.indexOf("?") >= 0 ? "&" : "?") + qs.join("&");
		}
		return __req.httpContext.generateUri(url);
	}

	public function encode(s : String)
	{
		return StringTools.urlEncode(s);
	}

	public function route(?data : Dynamic)
	{
		var hash = null;
		if(null == data)
			hash = new Map();
		else if (Std.is(data, Map))
			hash = Hashes.clone(data);
		else
			hash = DynamicsT.toHash(data);

		if (null == hash.get("controller"))
		{
			var route = __req.routeData.route.as(Route);
			if (null == route)
				throw new Error("unable to find a controller for {0}", Std.string(hash));
			hash.set("controller", route.defaults.get("controller"));
			if (null == hash.get("controller"))
				throw new Error("the routed data doesn't include the 'controller' parameter");
		}

		for(route in __req.routeData.route.routes.iterator())
		{
			var map = new StringMap();
			for (key in hash.keys())
			{
				map.set(key, hash.get(key));
			}
			var url = route.getPath(__req.httpContext, map);
			if(null != url)
				return url;
		}
		throw new Error("unable to find a suitable route for {0}", Std.string(hash));
	}
}
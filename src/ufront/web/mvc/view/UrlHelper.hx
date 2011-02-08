package ufront.web.mvc.view;             
import thx.error.Error;
import thx.error.NullArgument;
import ufront.web.mvc.IViewHelper;
import ufront.web.routing.RequestContext;
import ufront.web.routing.Route;
import thx.util.UDynamicT;
using thx.type.UType;
import thx.collections.UHash;
using thx.collections.UHash;

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
    
	public function register(data : Hash<Dynamic>)
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
			hash = new Hash();
		else if (Std.is(data, Hash))
			hash = UHash.clone(data);
		else
			hash = UDynamicT.toHash(data);
		
		if (null == hash.get("controller"))
		{
			var route = __req.routeData.route.as(Route);
			if (null == route)
				throw new Error("unable to find a suitable route for {0}", Std.string(hash));
			hash.set("controller", route.defaults.get("controller"));
			NullArgument.throwIfNull(hash.get("controller"), "controller");
		}
		
		for(route in __req.routeData.route.routes.iterator())
		{                  
			var url = route.getPath(__req.httpContext, hash.clone());
			if(null != url)
				return url;
		}
		throw new Error("unable to find a suitable route for {0}", Std.string(hash));
	}
}
package ufront.web.mvc.view;             
import thx.error.Error;
import thx.error.NullArgument;
import thx.util.UDynamicT;
import ufront.web.routing.RequestContext;
import ufront.web.routing.Route;

using thx.type.UType;

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
				qs.push(field + "=" + StringTools.urlEncode(value));
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

	public function route(?controllerName : String, ?action : String, ?data : Dynamic)
	{
		if (null == controllerName)
		{
			var route = __req.routeData.route.as(Route);
			if (null == route)
				throw new Error("action() method can't be used on this kind of route");
			controllerName = route.defaults.get("controller");
		}
		NullArgument.throwIfNull(controllerName, "controllerName");
		var hash = null;
		if(null == data)
			hash = new Hash();
		else if(!Std.is(data, Hash))
			hash = UDynamicT.toHash(data);
		else
			hash = data;
		
		hash.set("controller", controllerName);
		if(null != action)
			hash.set("action", action);      
        
		for(route in __req.routeData.route.routes.iterator())
		{                  
			var url = route.getPath(__req.httpContext, hash);       
			if(null != url)
				return url;
		}
		throw new Error("unable to find a suitable route for {0}", Std.string(hash));
	}
}
package ufront.web.mvc.view;             
import thx.error.Error;
import thx.error.NullArgument;
import thx.util.UDynamicT;
import ufront.web.routing.RequestContext;
import ufront.web.routing.Route;

using thx.type.UType;

class UrlHelper
{       
	public var requestContext(default, null) : RequestContext; 
	public function new(requestContext : RequestContext)
	{
		this.requestContext = requestContext;   
	}    
	   
	// TODO: base, base application url
	// TODO: current, calling context url
	
	public function base(?uri : String)
	{                                 
		if(null == uri)
			uri = "/";
		return requestContext.httpContext.generateUri(uri);
	}
	                        
	/**  
	*  @todo ad support for extra params
	*  */
	public function current(?params : Dynamic) 
	{                                    
		var url = requestContext.httpContext.getRequestUri();  
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
		return requestContext.httpContext.generateUri(url);
	}
	
	public function encode(s : String)
	{
		return StringTools.urlEncode(s);
	}               
	
	public function action(name : String, data : Dynamic<String>)
	{
		NullArgument.throwIfNull(name, "name");
		var route = requestContext.routeData.route.as(Route);
		if (null == route)
			throw new Error("action() method can't be used on this kind of route");
		return controller(route.defaults.get("controller"), name, data);
	} 
	
	public function controller(controllerName : String, ?action : String, ?data : Dynamic)
	{
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
        
		for(route in requestContext.routeData.route.routes.iterator())
		{                  
			var url = route.getPath(requestContext.httpContext, hash);       
			if(null != url)
				return url;
		}
		throw new Error("unable to find a suitable route for {0}", Std.string(hash));
	}
}
package ufront.web.mvc.view;             
import thx.error.Error;
import thx.error.NullArgument;
import thx.collections.UHash;
import ufront.web.routing.RequestContext;

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
	
	public function action(name : String, data : Dynamic)
	{           
		NullArgument.throwIfNull(name, "name");
		if(null == data)
			data = {}; 
		data.action = name;
		return requestContext.routeData.route.getPath(requestContext.httpContext, UHash.createHash(data));
	} 
	
	public function controller(controllerName : String, ?action : String, ?data : Dynamic)
	{
		NullArgument.throwIfNull(controllerName, "controllerName");
		if(null == data)
			data = {};
		data.controller = controllerName;
		if(null != action)
			data.action = action;      
        
//		trace(data);
		for(route in requestContext.routeData.route.routes.iterator())
		{                  
//			trace(route);
			var url = route.getPath(requestContext.httpContext, UHash.createHash(data));       
//			trace(url);
			if(null != url)
				return url;
		}
		throw new Error("unable to find a suitable route for {0}", Std.string(data));
	}
}
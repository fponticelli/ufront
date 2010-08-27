package ufront.web;
using thx.collections.UIterable;
import thx.error.NullArgument;
import ufront.web.HttpRequest;
import thx.error.Error;     

using StringTools;

class SegmentToParamUrlFilter implements IUrlFilter
{                                                                             
	public var defaultValue : String;
	public var allowedValues : Array<String>;                     
 //   public var currentSegment : String;    
	public var paramName : String;
	
	public function new(paramName : String, allowedValues : Array<String>, ?defaultValue : String)
	{   
		NullArgument.throwIfNull(paramName, "paramName");                                       
		NullArgument.throwIfNull(allowedValues, "allowedValues");
		this.paramName = paramName;    	
		this.defaultValue = defaultValue;
		this.allowedValues = allowedValues; 
  //  	this.currentSegment = null;
	} 
	
	public function filterIn(url : PartialUrl, request : HttpRequest)
	{   
		if(allowedValues.contains(url.segments[0]))  
		{
			var value = url.segments.shift();
			request.query.set(paramName, value);
		}                   
		
		/*     
		var parts = url.split("/");
		parts.shift();
		var first = parts.shift();
	    if(allowedDomains.contains(first))
	  	{
		    currentDomain = first;
			return "/" + parts.join("/");
		} else 
			return url;   
			*/
	}
	
	public function filterOut(url : VirtualUrl, request : HttpRequest)
	{   
		var params = url.query;
		if(params.exists(paramName))
		{
			var value = params.get(paramName).value;
			if(!allowedValues.contains(value))
				return;
			params.remove(paramName);
			if(value != defaultValue)
				url.segments.unshift(value);
		}    
		/* 
		if(url.segments[0] == defaultDomain)
		{
			url.segments.shift();
		}     
		*/
	}
}
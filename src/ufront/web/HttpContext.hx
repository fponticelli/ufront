/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;
import ufront.web.UrlDirection;
import udo.error.NullArgument;
import ufront.web.IUrlFilter;
import udo.error.AbstractMethod;
import ufront.web.session.FileSession;

class HttpContext
{	
	var _urlFilters : Array<IUrlFilter>;
	public static function createWebContext(?sessionpath : String)
	{
		var request = HttpRequestImpl.instance;
		if (null == sessionpath)
		{
			sessionpath = request.scriptDirectory + "../_sessions";
		}
		return new HttpContextImpl(request, HttpResponseImpl.instance, new FileSession(sessionpath));
	}
	
	public var request(getRequest, null) : HttpRequest;
	public var response(getResponse, null) : HttpResponse;
	public var session(getSession, null) : IHttpSessionState;
	
	public function getRequestUri() : String
	{
		var filtered = request.uri;
		for(filter in _urlFilters)
			filtered = filter.filter(filtered, UrlDirection.IncomingUrlRequest);
		return filtered;
	}
	
	public function generateUri(uri : String) : String
	{
		for(filter in _urlFilters)
			uri = filter.filter(uri, UrlDirection.UrlGeneration);
		return uri;
	}   
	
	public function addUrlFilter(filter : IUrlFilter)
	{                            
		NullArgument.throwIfNull(filter, "filter");
		_urlFilters.push(filter);
	}
	
	public function dispose() : Void;
	
	function getRequest() return throw new AbstractMethod()
	function getResponse() return throw new AbstractMethod()
	function getSession() return throw new AbstractMethod()

	function new()
	{
		_urlFilters = [];
	}
}
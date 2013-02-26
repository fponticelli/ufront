/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;
import ufront.web.UrlDirection;
import thx.error.NullArgument;
import ufront.web.IUrlFilter;
import thx.error.AbstractMethod;
import ufront.web.session.FileSession;

class HttpContext
{
	var _urlFilters : Array<IUrlFilter>;
	public static function createWebContext(?sessionpath : String, ?request : HttpRequest, ?response : HttpResponse)
	{
		if(null == request)
			request = HttpRequest.instance;
		if(null == response)
			response = HttpResponse.instance;
		if (null == sessionpath)
		{
			sessionpath = request.scriptDirectory + "../_sessions";
		}
		return new HttpContextImpl(request, response, FileSession.create(sessionpath));
	}

	public var request(get, null) : HttpRequest;
	public var response(get, null) : HttpResponse;
	public var session(get, null) : IHttpSessionState;

	var _requestUri : String;
	public function getRequestUri() : String
	{
		if(null == _requestUri)
		{
			var url = PartialUrl.parse(request.uri);
			for(filter in _urlFilters)
				filter.filterIn(url, request);
			_requestUri = url.toString();
		}
		return _requestUri;
	}

	public function generateUri(uri : String) : String
	{
		var uriOut = VirtualUrl.parse(uri);
		var i = _urlFilters.length - 1;
		while(i >= 0)
			_urlFilters[i--].filterOut(uriOut, request);
		return uriOut.toString();
	}

	public function addUrlFilter(filter : IUrlFilter)
	{
		NullArgument.throwIfNull(filter);
		_requestUri = null;
		_urlFilters.push(filter);
		return this;
	}

	public function clearUrlFilters()
	{
		_requestUri = null;
		_urlFilters = [];
	}

	public function dispose() : Void{}

	function get_request() return throw new AbstractMethod();
	function get_response() return throw new AbstractMethod();
	function get_session() return throw new AbstractMethod();

	function new()
	{
		_urlFilters = [];
	}
}
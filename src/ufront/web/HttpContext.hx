/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;

import udo.error.AbstractMethod;
import ufront.web.session.FileSession;

class HttpContext
{	
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
	public var requestUri(getRequestUri, setRequestUri) : String;
	
	public function dispose() : Void;
	
	function getRequest() return throw new AbstractMethod()
	function getResponse() return throw new AbstractMethod()
	function getSession() return throw new AbstractMethod()
	function getRequestUri()
	{
		return (null == requestUri) ?  request.uri : requestUri;
	}
	function setRequestUri(v : String)
	{
		return requestUri = v;
	}
	function new();
}
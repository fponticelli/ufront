/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;
import ufront.web.session.FileSession;
import udo.error.NullArgument;

class HttpContextImpl extends HttpContext
{
	public function new(request : HttpRequest, response : HttpResponse, session : IHttpSessionState)
	{
		super();
		this.request = request;
		this.response = response;
		this.session = session;
	}
	
	public function setRequest(request : HttpRequest)
	{
		NullArgument.throwIfNull(request, "request");
		this.request = request;
	}
	
	public function setResponse(response : HttpResponse)
	{
		NullArgument.throwIfNull(response, "response");
		this.response = response;
	}
	
	public function setSession(session : IHttpSessionState)
	{
		NullArgument.throwIfNull(session, "session");
		this.session = session;
	}
	
	override function getRequest() return request
	override function getResponse() return response
	override function getSession() return session
	
	override public function dispose():Void
	{
		session.dispose();
	}
}
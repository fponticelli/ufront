/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;
import ufront.web.session.FileSession;
import thx.error.NullArgument;

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
		NullArgument.throwIfNull(request);
		this.request = request;
	}
	
	public function setResponse(response : HttpResponse)
	{
		NullArgument.throwIfNull(response);
		this.response = response;
	}
	
	public function setSession(session : IHttpSessionState)
	{
		NullArgument.throwIfNull(session);
		this.session = session;
	}
	
	override function get_request() return request;
	override function get_response() return response;
	override function get_session() return session;
	
	override public function dispose():Void
	{
		session.dispose();
	}
}
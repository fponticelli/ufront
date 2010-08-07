/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.mock;

import ufront.web.HttpRequest;

class HttpRequestMock extends HttpRequest
{
	var _uploadHandler : IHttpUploadHandler;
	public function new()
	{
		query = new Hash();
		post = new Hash();
		cookies = new Hash();
		server = new Hash();
		queryString = "";
		postString = "";
		hostName = "";
		clientIP = "";
		uri = "";
		clientHeaders = new Hash();
		httpMethod = "";
		scriptDirectory = "";
		authorization = { user : null, pass : null };
		_uploadHandler = new EmptyUploadHandler();
	}
	
	override function getQuery() return query
	override function getPost() return post
	override function getCookies() return cookies
	override function getServer() return server
	override function getQueryString() return queryString
	override function getPostString() return postString
	override function getHostName() return hostName
	override function getClientIP() return clientIP
	override function getUri() return uri
	override function getClientHeaders() return clientHeaders
	override function getHttpMethod() return httpMethod
	override function getScriptDirectory() return scriptDirectory
	function getAuthorization() return authorization

	public function setQueryString(v : String) queryString = v
	public function setPostString(v : String) postString = v
	public function setHostName(v : String) hostName = v
	public function setClientIP(v : String) clientIp = v
	public function setUri(v : String) uri = v
	public function setHttpMethod(v : String) httpMethod = v
	public function setScriptDirectory(v : String) scriptDirectory = v
	
	override public function setUploadHandler(handler : IHttpUploadHandler) _uploadHandler = handler
}
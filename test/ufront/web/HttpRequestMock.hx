/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;
import ufront.web.EmptyUploadHandler;
import ufront.web.IHttpUploadHandler;
import ufront.web.HttpRequest;
import haxe.ds.StringMap;

class HttpRequestMock extends HttpRequest
{
	var _uploadHandler : IHttpUploadHandler;
	public function new()
	{
		query = new StringMap();
		post = new StringMap();
		cookies = new StringMap();
		queryString = "";
		postString = "";
		hostName = "";
		clientIP = "";
		uri = "";
		clientHeaders = new StringMap();
		httpMethod = "";
		scriptDirectory = "";
		authorization = { user : null, pass : null };
		_uploadHandler = new EmptyUploadHandler();
	}
	
	override function get_query() return query;
	override function get_post() return post;
	override function get_cookies() return cookies;
	override function get_queryString() return queryString;
	override function get_postString() return postString;
	override function get_hostName() return hostName;
	override function get_clientIP() return clientIP;
	override function get_uri() return uri;
	override function get_clientHeaders() return clientHeaders;
	override function get_httpMethod() return httpMethod;
	override function get_scriptDirectory() return scriptDirectory;
	override function get_authorization() return authorization;

	public function set_queryString(v : String) queryString = v;
	public function set_postString(v : String) postString = v;
	public function set_hostName(v : String) hostName = v;
	public function set_clientIP(v : String) clientIP = v;
	public function set_uri(v : String) uri = v;
	public function set_httpMethod(v : String) httpMethod = v;
	public function set_scriptDirectory(v : String) scriptDirectory = v;
	
	override public function setUploadHandler(handler : IHttpUploadHandler) _uploadHandler = handler;
}
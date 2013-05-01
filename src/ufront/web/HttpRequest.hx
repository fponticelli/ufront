/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;
import thx.collection.CascadeHash;
import thx.error.AbstractMethod;
import haxe.io.Bytes;
import haxe.ds.StringMap;
import thx.error.NotImplemented;

/**
* @todo remove the singleton
*/
class HttpRequest
{
  public static var instance(get, null) : HttpRequest;
	static function get_instance() : HttpRequest
	{
		if(null == instance)
#if php
        	instance = new php.ufront.web.HttpRequest();
#elseif neko
            instance = new neko.ufront.web.HttpRequest();
#else
    	throw new NotImplemented();
#end
		return instance;
	}

	/**
	 * The parameters are collected in the following order:
	 * - query-string parameters
	 * - post values
	 * - cookies
	 */
 	public var params(get, null) : CascadeHash<String>;
 	function get_params()
 	{
 		if (null == params)
 			params = new CascadeHash([new StringMap(), query, post, cookies]);
 		return params;
 	}

 	public var queryString(get, null) : String;
 	function get_queryString() return throw new AbstractMethod();

 	public var postString(get, null) : String;
 	function get_postString() return throw new AbstractMethod();

 	public var query(get, null) : StringMap<String>;
 	function get_query() return throw new AbstractMethod();

 	public var post(get, null) : StringMap<String>;
 	function get_post() return throw new AbstractMethod();

 	public var cookies(get, null) : StringMap<String>;
 	function get_cookies() return throw new AbstractMethod();

 	public var hostName(get, null) : String;
 	function get_hostName() return throw new AbstractMethod();

 	public var clientIP(get, null) : String;
 	function get_clientIP() return throw new AbstractMethod();

 	public var uri(get, null) : String;
 	function get_uri() return throw new AbstractMethod();

 	public var clientHeaders(get, null) : StringMap<String>;
 	function get_clientHeaders() return throw new AbstractMethod();

	public var userAgent(get, null) : UserAgent;
 	function get_userAgent() return throw new AbstractMethod();

 	public var httpMethod(get, null) : String;
 	function get_httpMethod() return throw new AbstractMethod();

 	public var scriptDirectory(get, null) : String;
 	function get_scriptDirectory() return throw new AbstractMethod();

 	public var authorization(get, null) : { user : String, pass : String };
 	function get_authorization() return throw new AbstractMethod();

 	public function setUploadHandler(handler : IHttpUploadHandler) throw new AbstractMethod();

	// urlReferrrer
	//public var acceptTypes(get, null) : Array<String>;
	//public var sessionId(get, null) : String;

	/**
	 * never has trailing slash. If the application is in the server root the path will be emppty ""
	 */
	//public var applicationPath(get, null) : String;
	//public var broswer(get, setBrowser) : HttpBrowserCapabilities;
	//public var encoding(get, setEncoding) : String;
	//public var contentLength(get, null) : Int;
	//public var contentType(get, null) : String;
	//public var mimeType(get, setMimeType) : String;
	//public var files(get, null) : List<HttpPostedFile>;
	//public var httpMethod(get, null) : String;
	//public var isAuthenticated(get, null) : String;
	/**
	 * evaluates to true if the IP address is 127.0.0.1 or the same as the client ip address
	 */
	//public var isLocal(get, null) : String;
	//public var isSecure(get, null) : String;

	//public var userAgent(get, null) : String;
	//public var userHostAddress(get, null) : String;
	//public var userHostName(get, null) : String;
	//public var userLanguages(get, null) : Array<String>;
}
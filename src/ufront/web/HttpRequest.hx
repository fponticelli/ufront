/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;
import thx.collections.CascadeHash;
import thx.error.AbstractMethod;
import haxe.io.Bytes;

/**
* @todo remove the singleton 
*/
class HttpRequest
{    
  public static var instance(getInstance, null) : HttpRequest;
	static function getInstance() : HttpRequest 
	{  
		if(null == instance)
#if php
        	instance = new php.ufront.web.HttpRequest();
#elseif neko
            instance = new neko.ufront.web.HttpRequest();
#elseif nodejs
			instance = null;
#else
    	NOT IMPLEMENTED PLATFORM
#end
		return instance;
	}
	
	/**
	 * The parameters are collected in the following order:                    
	 * - query-string parameters
	 * - post values
	 * - cookies
	 */
 	public var params(getParams, null) : Hash<String>;
 	function getParams()
 	{
 		if (null == params)
 			params = CascadeHash.create([new Hash(), query, post, cookies]);
 		return params;
 	}

 	public var queryString(getQueryString, null) : String;
 	function getQueryString() return throw new AbstractMethod()

 	public var postString(getPostString, null) : String;
 	function getPostString() return throw new AbstractMethod()

 	public var query(getQuery, null) : Hash<String>;
 	function getQuery() return throw new AbstractMethod()

 	public var post(getPost, null) : Hash<String>;
 	function getPost() return throw new AbstractMethod()

 	public var cookies(getCookies, null) : Hash<String>;
 	function getCookies() return throw new AbstractMethod()

 	public var hostName(getHostName, null) : String;
 	function getHostName() return throw new AbstractMethod()

 	public var clientIP(getClientIP, null) : String;
 	function getClientIP() return throw new AbstractMethod()

 	public var uri(getUri, null) : String;
 	function getUri() return throw new AbstractMethod()

 	public var clientHeaders(getClientHeaders, null) : Hash<String>;
 	function getClientHeaders() return throw new AbstractMethod()

 	public var httpMethod(getHttpMethod, null) : String;
 	function getHttpMethod() return throw new AbstractMethod()

 	public var scriptDirectory(getScriptDirectory, null) : String;
 	function getScriptDirectory() return throw new AbstractMethod()

 	public var authorization(getAuthorization, null) : { user : String, pass : String };
 	function getAuthorization() return throw new AbstractMethod()

 	public function setUploadHandler(handler : IHttpUploadHandler) throw new AbstractMethod()
	
	// urlReferrrer
	//public var acceptTypes(getAcceptTypes, null) : Array<String>;
	//public var sessionId(getSessionId, null) : String;
	
	/**
	 * never has trailing slash. If the application is in the server root the path will be emppty ""
	 */
	//public var applicationPath(getApplicationPath, null) : String;
	//public var broswer(getBrowser, setBrowser) : HttpBrowserCapabilities;
	//public var encoding(getEncoding, setEncoding) : String;
	//public var contentLength(getContentLength, null) : Int;
	//public var contentType(getContentType, null) : String;
	//public var mimeType(getMimeType, setMimeType) : String;
	//public var files(getFiles, null) : List<HttpPostedFile>;
	//public var httpMethod(getHttpMethod, null) : String;
	//public var isAuthenticated(getIsAuthenticated, null) : String;
	/**
	 * evaluates to true if the IP address is 127.0.0.1 or the same as the client ip address
	 */
	//public var isLocal(getIsLocal, null) : String;
	//public var isSecure(getIsSecure, null) : String;
	
	//public var userAgent(getUserAgent, null) : String;
	//public var userHostAddress(getUserHostAddress, null) : String;
	//public var userHostName(getUserHostName, null) : String;
	//public var userLanguages(get, null) : Array<String>;
}
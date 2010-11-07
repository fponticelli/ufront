/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;
import haxe.io.BytesOutput;
import haxe.io.Output;
import thx.collections.HashList;
import thx.error.NullArgument;
  
/**
* @todo remove the singleton 
*/
class HttpResponse
{
	public static var instance(getInstance, null) : HttpResponse;
	static function getInstance() : HttpResponse 
	{
		if(null == instance)
#if php
        	instance = new php.ufront.web.HttpResponse();
#elseif neko
            instance = new neko.ufront.web.HttpResponse(); 
#elseif nodejs                                             
			instance = null;
#else
    	NOT IMPLEMENTED PLATFORM
#end
		return instance;
	}

	static inline var CONTENT_TYPE = "Content-type";
	static inline var LOCATION = "Location";
	static inline var DEFAULT_CONTENT_TYPE = "text/html";
	static inline var DEFAULT_CHARSET = "utf-8";
	static inline var DEFAULT_STATUS = 200;
	static inline var MOVED_PERMANENTLY = 301;
	static inline var FOUND = 302;
	static inline var UNAUTHORIZED = 401;
	static inline var NOT_FOUND = 404;
	static inline var INTERNAL_SERVER_ERROR = 500;
	
	public var contentType(getContentType, setContentType) : String;
	public var redirectLocation(getRedirectLocation, setRedirectLocation) : String;
	public var charset : String;
	public var status : Int;

	var _buff : StringBuf;
	var _headers : HashList<String>;
	var _cookies : Hash<HttpCookie>;
	
	public function new()
	{
		clear();
		contentType = null;
		charset = DEFAULT_CHARSET;
		status = DEFAULT_STATUS;
	}
	
	public function flush() : Void;
	public function clear()
	{
		clearCookies();
		clearHeaders();
		clearContent();
	}
	
	public function clearCookies()
	{
		_cookies = new Hash();
	}
	
	public function clearContent()
	{
		_buff = new StringBuf();
	}
	
	public function clearHeaders()
	{
		_headers = new HashList();
	}
	
	public function write(s : String)
	{   
		if(null != s)
			_buff.add(s);
	}
	
	public function writeChar(c : Int)
	{
		_buff.addChar(c);
	}
	
	public function setHeader(name : String, value : String)
	{
		NullArgument.throwIfNull(name, "name");
		NullArgument.throwIfNull(value, "value");
		_headers.set(name, value);
	}
	
	public function setCookie(cookie : HttpCookie)
	{
		_cookies.set(cookie.name, cookie);
	}
	
	public function getBuffer()
	{
		return _buff.toString();
	}
	
	public function getCookies()
	{
		return _cookies;
	}
	
	public function getHeaders()
	{
		return _headers;
	}
	
	public function redirect(url : String)
	{
		status = FOUND;
		redirectLocation = url;
	}
	
	public function setOk()
	{
		status = DEFAULT_STATUS;
	}
	
	public function setUnauthorized()
	{
		status = UNAUTHORIZED;
	}
	
	public function setNotFound()
	{
		status = NOT_FOUND;
	}
	
	public function setInternalError()
	{
		status = INTERNAL_SERVER_ERROR;
	}
	
	public function permanentRedirect(url : String)
	{
		status = MOVED_PERMANENTLY;
		redirectLocation = url;
	}
	
	public function isRedirect()
	{
		return Math.floor(status / 100) == 3;
	}
	
	public function isPermanentRedirect()
	{
		return status == MOVED_PERMANENTLY;
	}
	
	function getContentType()
	{
		return _headers.get(CONTENT_TYPE);
	}
	
	function setContentType(v : String)
	{
		if (null == v)
			_headers.set(CONTENT_TYPE, DEFAULT_CONTENT_TYPE)
		else
			_headers.set(CONTENT_TYPE, v);
		return v;
	}
	
	function getRedirectLocation()
	{
		return _headers.get(LOCATION);
	}
	
	function setRedirectLocation(v : String)
	{
		if (null == v)
			_headers.remove(LOCATION)
		else
			_headers.set(LOCATION, v);
		return v;
	}
}
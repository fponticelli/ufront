/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;
import haxe.io.BytesOutput;
import haxe.io.Output;
import thx.collection.HashList;
import thx.error.NullArgument;
import haxe.ds.StringMap;

class HttpResponseBase
{
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

	public var contentType(get, set) : String;
	public var redirectLocation(get, set) : String;
	public var charset : String;
	public var status : Int;

	var _buff : StringBuf;
	var _headers : HashList<String>;
	var _cookies : StringMap<HttpCookie>;

	public function new()
	{
		clear();
		contentType = null;
		charset = DEFAULT_CHARSET;
		status = DEFAULT_STATUS;
	}

	public function flush() : Void{}
	public function clear()
	{
		clearCookies();
		clearHeaders();
		clearContent();
	}

	public function clearCookies()
	{
		_cookies = new StringMap();
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
		NullArgument.throwIfNull(name);
		NullArgument.throwIfNull(value);
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

	function get_contentType()
	{
		return _headers.get(CONTENT_TYPE);
	}

	function set_contentType(v : String)
	{
		if (null == v)
			_headers.set(CONTENT_TYPE, DEFAULT_CONTENT_TYPE)
		else
			_headers.set(CONTENT_TYPE, v);
		return v;
	}

	function get_redirectLocation()
	{
		return _headers.get(LOCATION);
	}

	function set_redirectLocation(v : String)
	{
		if (null == null)
			_headers.remove(LOCATION)
		else
			_headers.set(LOCATION, v);
		return v;
	}
}
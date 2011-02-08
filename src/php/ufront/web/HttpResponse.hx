/**
 * ...
 * @author Franco Ponticelli
 */

package php.ufront.web;

import thx.sys.Lib;
import thx.error.Error;

using StringTools;

class HttpResponse extends ufront.web.HttpResponse
{
	var _flushed : Bool;
	
	public function new()
	{
		super();
		_flushed = false;
	}
	
	override function flush()
	{
		if (_flushed) return;
		_flushed = true;
		var k = null, v = null;
		
		// set status
		untyped __call__('header', 'X-Powered-By: ufront', true);
		untyped __call__('header', "HTTP/1.1 " + statusDescription(status), true, status);
		
		try {
			for (cookie in _cookies)
			{
				var expire = cookie.expires == null ? 0 : cookie.expires.getTime() / 1000;
				untyped __call__("setcookie", cookie.name, cookie.value, expire, cookie.path, cookie.domain, cookie.secure);
			}
		} catch (e : Dynamic)
		{
			throw new Error("you can't set the cookie, output already sent");
		}
		
		try {
			// write headers
			for (key in _headers.keys())
			{
				k = key;
				v = _headers.get(key);
				if (k == "Content-type" && null != charset && v.startsWith('text/'))
				{
					v += "; charset=" + charset;
				}
				untyped __call__("header", v == null ? key : key + ": " + v, true);
			}
		} catch (e : Dynamic)
		{
			throw new Error("invalid header: '{0}: {1}' or output already sent", [k, v]);
		}
		// write content
		Lib.print(_buff.toString());
	}
	
	public static function statusDescription( r : Int )
	{
		switch(r) {
			case 100: return "100 Continue";
			case 101: return "101 Switching Protocols";
			case 200: return "200 Continue";
			case 201: return "201 Created";
			case 202: return "202 Accepted";
			case 203: return "203 Non-Authoritative Information";
			case 204: return "204 No Content";
			case 205: return "205 Reset Content";
			case 206: return "206 Partial Content";
			case 300: return "300 Multiple Choices";
			case 301: return "301 Moved Permanently";
			case 302: return "302 Found";
			case 303: return "303 See Other";
			case 304: return "304 Not Modified";
			case 305: return "305 Use Proxy";
			case 307: return "307 Temporary Redirect";
			case 400: return "400 Bad Request";
			case 401: return "401 Unauthorized";
			case 402: return "402 Payment Required";
			case 403: return "403 Forbidden";
			case 404: return "404 Not Found";
			case 405: return "405 Method Not Allowed";
			case 406: return "406 Not Acceptable";
			case 407: return "407 Proxy Authentication Required";
			case 408: return "408 Request Timeout";
			case 409: return "409 Conflict";
			case 410: return "410 Gone";
			case 411: return "411 Length Required";
			case 412: return "412 Precondition Failed";
			case 413: return "413 Request Entity Too Large";
			case 414: return "414 Request-URI Too Long";
			case 415: return "415 Unsupported Media Type";
			case 416: return "416 Requested Range Not Satisfiable";
			case 417: return "417 Expectation Failed";
			case 500: return "500 Internal Server Error";
			case 501: return "501 Not Implemented";
			case 502: return "502 Bad Gateway";
			case 503: return "503 Service Unavailable";
			case 504: return "504 Gateway Timeout";
			case 505: return "505 HTTP Version Not Supported";
			default: return Std.string(r);
		}
	}
}
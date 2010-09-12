/**
 * ...
 * @author Franco Ponticelli
 */

package neko.ufront.web;

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
		_set_return_code(status);
		
		try 
		{
			for (cookie in _cookies)
				_set_cookie(untyped cookie.name.__s, untyped cookie.description().__s);
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
				_set_header(untyped key.__s, untyped v.__s);
			}
		} catch (e : Dynamic)
		{
			throw new Error("invalid header: '{0}: {1}' or output already sent", [k, v]);
		}
		// write content
		Lib.print(_buff.toString());
	}
	
	static var _set_header : Dynamic;
	static var _set_cookie : Dynamic;
	static var _set_return_code : Dynamic;
	static function __init__()
	{
		var get_env = Lib.load("std", "get_env", 1);
		var ver = untyped get_env("MOD_NEKO".__s);
		var lib = "mod_neko" + if ( ver == untyped "1".__s ) "" else ver;
		_set_header = Lib.load(lib, "set_header", 2);
		_set_cookie = Lib.load(lib, "set_cookie", 2);
		_set_return_code = Lib.load(lib,"set_return_code",1);
	}
}
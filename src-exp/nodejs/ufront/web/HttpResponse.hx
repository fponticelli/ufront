/**
 * ...
 * @author Franco Ponticelli
 */

package nodejs.ufront.web;
import thx.error.NotImplemented; 
import js.Node;
import thx.error.Error; 
using StringTools;

class HttpResponse extends ufront.web.HttpResponse
{    
	var _flushed : Bool; 
	var _r : Response;
	public function new(response : Response)
	{
		super();
		_r = response;
		_flushed = false;
	}
	
	override function flush()
	{
		if (_flushed) return;
		_flushed = true;
		//status 
		
		var headers = {}, k, v;
		for (key in _headers.keys())
		{
			k = key;
			v = _headers.get(key);
			if (k == "Content-type" && null != charset && v.startsWith('text/'))
				v += "; charset=" + charset;
			Reflect.setField(headers, key, v);
		}                                   
   		
		_r.writeHead(status, null, headers);
		_r.write(_buff.toString());
		_r.end();
/*
		
		try 
		{
			for (cookie in _cookies)
				_set_cookie(untyped cookie.name.__s, untyped cookie.description().__s);
		} catch (e : Dynamic)
		{
			throw new Error("you can't set the cookie, output already sent");
		}
*/
	}
}
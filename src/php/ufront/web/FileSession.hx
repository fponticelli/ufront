/**
 * ...
 * @author Andreas Söderlund
 */

package php.ufront.web;
import ufront.web.IHttpSessionState;

import thx.sys.Lib;
import php.Session;

class FileSession implements IHttpSessionState
{
	public function new(savePath : String)
	{
//		Session.setCacheLimiter(PrivateNoExpire);
		Session.setCacheExpire(60 * 24 * 10);
		
		Session.setSavePath(savePath);
	}

	public function dispose() : Void
	{
		if (!Session.started)
			return;
		untyped __call__("session_write_close");
	}

	public function clear() : Void
	{
		untyped __call__("session_unset");
	}

	public function get(name : String) : Dynamic
	{
		var value : String = Session.get(name);
		if(value == null)
			return null;
		else
			return Lib.unserialize(value);
	}

	public function set(name : String, value : Dynamic) : Void
	{
		Session.set(name, Lib.serialize(value));
	}

	public function exists(name : String) : Bool
	{
		return Session.exists(name);
	}

	public function remove(name : String) : Void
	{
		Session.remove(name);
	}
	
	public function id() : String
	{
		return Session.getId();
	}
}
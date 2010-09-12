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
		return Lib.unserialize(Session.get(name));
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
}
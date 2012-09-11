package neko.ufront.web;

/**
 * ...
 * @author Andreas Söderlund
 */

import ufront.web.IHttpSessionState;

import thx.sys.Lib;
using StringTools;
import neko.ufront.web.NekoSession;

class FileSession implements IHttpSessionState
{
    // added remember parameter to allow
    // for non-persistent sessions to be created.
    // default to false to keep compatibility with
    // existing source code
	public function new(savePath : String,?remember:Bool=false)
	{
		savePath = savePath.replace("\\", "/");
		if (!savePath.endsWith("/"))
			savePath += "/";
		NekoSession.setSavePath(savePath);

        if (remember)
            NekoSession.setCookieParams(60 * 24 * 10);
	}

	public function dispose() : Void
	{
		if (!NekoSession.started)
			return;
		NekoSession.close();
	}

	public function clear() : Void
	{
		NekoSession.clear();
	}

	public function get(name : String) : Dynamic
	{
		return NekoSession.get(name);
	}

	public function set(name : String, value : Dynamic) : Void
	{
		NekoSession.set(name, value);
	}

	public function exists(name : String) : Bool
	{
		return NekoSession.exists(name);
	}

	public function remove(name : String) : Void
	{
		NekoSession.remove(name);
	}
	
	public function id() : String
	{
		return NekoSession.id;
	}
}
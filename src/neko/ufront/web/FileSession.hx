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
    public function setLifeTime(lifetime:Int){
    	if(lifetime!=0)
    		NekoSession.setCookieParams(lifetime);
    }

    
	public function new(savePath : String)
	{
		savePath = savePath.replace("\\", "/");
		if (!savePath.endsWith("/"))
			savePath += "/";
		NekoSession.setSavePath(savePath);

        
            
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
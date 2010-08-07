/**
 * ...
 * @author Andreas Söderlund
 */

package ufront.web.session;
import ufront.web.IHttpSessionState;

import udo.neutral.Lib;
using StringTools;
#if php
typedef InternalSession = php.Session;
#elseif neko
typedef InternalSession = ufront.web.session.NekoSession;
#end

class FileSession implements IHttpSessionState
{
	public function new(savePath : String)
	{
		savePath = savePath.replace("\\", "/");
		if (!savePath.endsWith("/"))
			savePath += "/";
		InternalSession.setSavePath(savePath);
	}

	public function dispose() : Void
	{
		if (!InternalSession.started)
			return;
		#if php
		untyped __call__("session_write_close");
		#elseif neko
		InternalSession.close();
		#end
	}

	public function clear() : Void
	{
		#if php
		untyped __call__("session_unset");
		#elseif neko
		InternalSession.clear();
		#end
	}

	public function get(name : String) : Dynamic
	{
#if php
		return Lib.unserialize(InternalSession.get(name));
#elseif neko
		return InternalSession.get(name);
#end
	}

	public function set(name : String, value : Dynamic) : Void
	{
#if php
		InternalSession.set(name, Lib.serialize(value));
#elseif neko
		InternalSession.set(name, value);
#end
	}

	public function exists(name : String) : Bool
	{
		return InternalSession.exists(name);
	}

	public function remove(name : String) : Void
	{
		InternalSession.remove(name);
	}
}

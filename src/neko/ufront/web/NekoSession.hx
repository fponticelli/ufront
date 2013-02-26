/**
 * ...
 * @author Andreas Söderlund
 */

#if neko
package neko.ufront.web;

import sys.FileSystem;
import neko.Lib;
import neko.Web;
import Sys;
import haxe.io.Bytes;
import haxe.ds.StringMap;

class NekoSession
{
	private static var SID : String = 'NEKOSESSIONID';

	public static var started(default, null) : Bool;
	public static var id(default, set) : String;
	public static var savePath(default, set) : String;
	private static var sessionData : StringMap<Dynamic>;
	public static var sessionName(default, set) : String;
	private static var needCommit : Bool;

	public static function set_sessionName(name : String)
	{
		if( started ) throw "Can't set name after Session start.";
		sessionName=name;
		return name;
	}

	public static function get_id() : String return id;

	public static function set_id(_id : String) : String
	{
		if( started ) throw "Can't set id after Session.start.";

		testValidId(_id);

		id = _id;
		return id;
	}

	public static function get_savePath() : String return savePath;

	public static function set_savePath(path : String) : String
	{
		if(started) throw "You can't set the save path while the session is already in use.";
		savePath = path;
		return path;
	}

	public static function get_module() : String
	{
		throw "Not implemented.";
		return "";
	}

	public static function set_module(module : String)
	{
		if(started) throw "You can't set the module while the session is already in use.";
		throw "Not implemented.";
		return "";
	}

	public static function regenerateId(?deleteold : Bool) : Bool
	{
		throw "Not implemented.";
		return false;
	}

	public static function get(name : String) : Dynamic
	{
		start();
		return sessionData.get(name);
	}

	public static function set(name : String, value : Dynamic)
	{
		start();
		needCommit = true;
		sessionData.set(name, value);
	}

	static var lifetime = 0;
	static var path = '/'; // TODO: Set cookie path to application path, right now it's global.
	static var domain = null; 
	static var secure = false;
	static var httponly = false;

	public static function setCookieParams(?lifetimeIn : Int, ?pathIn : String, ?domainIn : String, ?secureIn : Bool, ?httponlyIn : Bool)
	{
		if(started) throw "You can't set the cookie params while the session is already in use.";

		if (lifetimeIn != null) lifetime = lifetimeIn;
		if (pathIn != null) path = pathIn;
		if (domainIn != null) domain = domainIn;
		if (secureIn != null) secure = secureIn; 
		if (httponlyIn != null) httponly = httponlyIn;
	}

	public static function getCookieParams() :
	{ lifetime : Int, path : String, domain : String, secure : Bool, httponly : Bool}
	{
		throw "Not implemented.";
		return null;
	}

	public static function setSaveHandler(open : String -> String -> Bool, close : Void -> Bool, read : String -> String, write : String -> String -> Bool, destroy, gc) : Bool
	{
		throw "Not implemented.";
		return false;
	}

	public static function exists(name : String)
	{
		start();
		return sessionData.exists(name);
	}

	public static function remove(name : String)
	{
		start();
		needCommit = true;
		sessionData.remove(name);
	}

	public static function start()
	{
		if (started) return;
		needCommit = false;
		if( sessionName == null ) sessionName = SID;

		if( savePath == null )
			savePath = Sys.getCwd();
		else
		{
			// Test if savepath exists. Need to remove last slash in path, otherwise FileSystem.exists() throws an exception.
			var testPath = (StringTools.endsWith(savePath, '/') || StringTools.endsWith(savePath, '\\')) ? savePath.substr(0, savePath.length - 1) : savePath;

			if(!FileSystem.exists(testPath))
				throw 'Neko session savepath not found: ' + testPath;
		}

		if( id==null )
		{
			var params = Web.getParams();
			id = params.get(sessionName);
			//trace("getting id from req: " + id);
		}
		if( id==null )
		{
			var cookies = Web.getCookies();
			id = cookies.get(sessionName);
			//trace("getting id from cookie: " + id);
		}
		if( id==null )
		{
			var args = Sys.args();
			for( a in args )
			{
				var s = a.split("=");
				if( s[0] == sessionName )
				{
					id=s[1];
					break;
				}
			}
			//trace("getting id from command line");
		}

		var file : String;
		var fileData : Bytes;

		if( id!=null )
		{
			testValidId(id);

			file = savePath + id + ".sess";
			if( !sys.FileSystem.exists(file) )
				id = null;
			else
			{
				fileData = try sys.io.File.getBytes(file) catch ( e:Dynamic ) null;
				if( fileData == null )
				{
					id = null;
					try sys.FileSystem.deleteFile(file) catch( e:Dynamic ) null;
				}
				else
				{
					sessionData = Lib.unserialize(fileData);
				}
			}
		}
		if( id==null )
		{
			//trace("no id found, creating a new session.");
			sessionData = new StringMap<Dynamic>();

			do
			{
				id = haxe.crypto.Md5.encode(Std.string(Math.random() + Math.random()));
				file = savePath + id + ".sess";
			} while( sys.FileSystem.exists(file) );

			var expire = (lifetime == 0) ? null : DateTools.delta(Date.now(), 1000.0 * lifetime);
			Web.setCookie(SID, id, expire, domain, path, secure);

			started = true;
			commit();
		}
		started = true;
	}

	public static function clear()
	{
		sessionData = new StringMap<Dynamic>();
	}

	private static function commit()
	{
		if( !started ) return;
		try
		{
			var w = sys.io.File.write(savePath + id + ".sess", true),
				b = Lib.serialize(sessionData);
			w.writeBytes(b, 0, b.length);
			w.close();
		}
		catch(e : Dynamic)
		{
			// Session is gone, ignore it.
		}
	}

	public static function close(?forceCommit = false)
	{
		if( needCommit || forceCommit ) commit();
		started = false;
	}

	/////////////////////////////////////////////////////////////////

	private static inline function testValidId(id : String) : Void
	{
		if(id != null)
		{
			var validId : EReg = ~/^[a-zA-Z0-9]+$/;
			if(!validId.match(id))
				throw "Invalid session ID.";
		}
	}

	static function __init__()
	{
		started = false;
	}
}

enum CacheLimiter
{
	Public;
	Private;
	NoCache;
	PrivateNoExpire;
}
#end
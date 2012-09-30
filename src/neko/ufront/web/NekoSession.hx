/**
 * ...
 * @author Andreas Söderlund
 */

#if neko
package neko.ufront.web;

import neko.FileSystem;
import neko.Lib;
import neko.Web;
import neko.Sys;
import haxe.io.Bytes;

class NekoSession
{
	private static var SID : String = 'NEKOSESSIONID';

	public static var started(default, null) : Bool;
	public static var id(default, setId) : String;
	public static var savePath(default, setSavePath) : String;
	private static var sessionData : Hash<Dynamic>;
	public static var sessionName(default, setName) : String;
	private static var needCommit : Bool;

	public static function setName(name : String)
	{
		if( started ) throw "Can't set name after Session start.";
		sessionName=name;
		return name;
	}

	public static function getName() : String
	{
		return sessionName;
	}

	public static function getId() : String return id

	public static function setId(_id : String) : String
	{
		if( started ) throw "Can't set id after Session.start.";

		testValidId(_id);

		id = _id;
		return id;
	}

	public static function getSavePath() : String return savePath

	public static function setSavePath(path : String) : String
	{
		if(started) throw "You can't set the save path while the session is already in use.";
		savePath = path;
		return path;
	}

	public static function getModule() : String
	{
		throw "Not implemented.";
		return "";
	}

	public static function setModule(module : String)
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

	public static function setCookieParams(?lifetime : Int, ?path : String, ?domain : String, ?secure : Bool, ?httponly : Bool)
	{
		if(started) throw "You can't set the cookie params while the session is already in use.";
		throw "Not implemented.";
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
			savePath = neko.Sys.getCwd();
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
			if( !neko.FileSystem.exists(file) )
				id = null;
			else
			{
				fileData = try neko.io.File.getBytes(file) catch ( e:Dynamic ) null;
				if( fileData == null )
				{
					id = null;
					try neko.FileSystem.deleteFile(file) catch( e:Dynamic ) null;
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
			sessionData = new Hash<Dynamic>();

			do
			{
				id = haxe.Md5.encode(Std.string(Math.random() + Math.random()));
				file = savePath + id + ".sess";
			} while( neko.FileSystem.exists(file) );

			// TODO: Set cookie path to application path, right now it's global.
			Web.setCookie(SID, id, null, null, '/');

			started = true;
			commit();
		}
		started = true;
	}

	public static function clear()
	{
		sessionData = new Hash<Dynamic>();
	}

	private static function commit()
	{
		if( !started ) return;
		try
		{
			var w = neko.io.File.write(savePath + id + ".sess", true),
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
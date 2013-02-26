package ufront.auth.adapter;
import thx.error.Error;
import ufront.auth.AuthResult;
import ufront.auth.AuthResultMessage;
import ufront.auth.IAuthAdapter;
import thx.error.NullArgument;
import thx.sys.FileSystem;
import thx.sys.io.File; 
import haxe.io.Eof; 
import thx.util.Message;
using StringTools;

class Digest implements IAuthAdapter<Identity>
{       
	public var filename : String;
	public var realm : String;
	public var username : String;
	public var password : String;
	
	public function new(?filename : String, ?realm : String, ?username : String, ?password : String)
	{
		this.filename = filename;
		this.realm = realm;
		this.username = username;
		this.password = password;
	}
	
	public function authenticate()
	{
		NullArgument.throwIfNull(filename);
		NullArgument.throwIfNull(realm);
		NullArgument.throwIfNull(username);
		NullArgument.throwIfNull(password);
		if(!FileSystem.exists(filename))
			throw new Error("authentication file '{0}' does not exists", filename);
		
		var identity = { realm : realm, username : username };
		var id = username + ":" + realm;
		
		var file = File.read(filename, false);
		
		var close = function(message) {
			file.close();
			return new AuthResult(message, identity);
		};
		
		try
		{
			while(true)
			{
				var line = file.readLine().trim();
				if(line.startsWith(id))
				{
					if(line.substr(-32) == haxe.crypto.Md5.encode(username + ":" + realm + ":" + password))
						return close(Success);
					else
						return close(InvalidCredential(new Message('password incorrect')));
				}
			}
		} catch(e : Eof){}
		
		return close(IdentityNotFound(new Message("username '{0}' and realm '{1}' combination not found", [username, realm])));
	}
}

typedef Identity = {
	realm : String,
	username : String
}
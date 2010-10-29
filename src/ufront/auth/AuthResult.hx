package ufront.auth;

class AuthResult<T>
{   
	public var isvalid(default, null) : Bool;
	public var message(default, null) : AuthResultMessage;
	public var identity(default, null) : T;
	public function new(msg : AuthResultMessage, ?identity : T)
	{
		switch(msg)
		{
			case Success: isvalid = true;
			default: isvalid = false;
		}
		message = msg;
		this.identity = identity;
	}	
}
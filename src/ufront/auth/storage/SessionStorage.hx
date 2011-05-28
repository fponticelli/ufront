package ufront.auth.storage;    
import ufront.auth.IAuthStorage;
import ufront.web.IHttpSessionState;
import thx.error.NullArgument;

class SessionStorage<T> implements IAuthStorage<T>
{                       
	inline public static var DEFAULT_VARIABLE_NAME = "auth_session_storage"; 
	var _name : String;
	var _session : IHttpSessionState;
	public function new(session : IHttpSessionState, ?name : String)
	{
		NullArgument.throwIfNull(session);
		_session = session;
		if(null == name)
			_name = DEFAULT_VARIABLE_NAME;
		else
			_name = name;
	}
	
	public function isEmpty()
	{
		return !_session.exists(_name);
	}
	
	public function clear()
	{
		_session.remove(_name);
	}
	
	public function read() : T
	{
		return _session.get(_name);
	}
	
	public function write(value : T)
	{
		_session.set(_name, value);
	}
}
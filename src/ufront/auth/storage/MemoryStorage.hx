package ufront.auth.storage;    
import ufront.auth.IAuthStorage;
import ufront.web.IHttpSessionState;
import thx.error.NullArgument;

class MemoryStorage<T> implements IAuthStorage<T>
{                       
	var _data : Null<T>;
	public function new()
	{
	}
	
	public function isEmpty()
	{
		return null != _data;
	}
	
	public function clear()
	{
		_data = null;
	}
	
	public function read() : T
	{
		return _data;
	}
	
	public function write(value : T)
	{
		_data = value;
	}
}
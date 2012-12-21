package ufront.web;
import ufront.web.IHttpSessionState;

class HttpSessionStateMock implements IHttpSessionState
{
	var _h : Hash<Dynamic>;
	public function new()
	{
		_h = new Hash();
	}

	public function dispose() : Void
	{
		_h = null;
	}

	public function clear() : Void
	{
		_h = new Hash();
	}

	public function get(name : String) : Dynamic
	{
		return _h.get(name);
	}

	public function set(name : String, value : Dynamic) : Void
	{
		_h.set(name, value);
	}

	public function exists(name : String) : Bool
	{
		return _h.get(name);
	}

	public function remove(name : String) : Void
	{
		_h.remove(name);
	}
	
	public function id() : String
	{
		return "mock";
	}

	public function setLifeTime(lifetime:Int)
	{
	
	 	
	}
}
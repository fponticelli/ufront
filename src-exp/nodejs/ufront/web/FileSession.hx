/**
 * ...
 * @author Andreas Söderlund
 */

package nodejs.ufront.web;
import ufront.web.IHttpSessionState;  
import thx.error.NotImplemented;

class FileSession implements IHttpSessionState
{
	public function new(savePath : String, ?expire : Int = 0)
	{                              

	}

	public function dispose() : Void
	{
//		throw new NotImplemented();
	}

	public function clear() : Void
	{
		throw new NotImplemented();
	}

	public function get(name : String) : Dynamic
	{
		return throw new NotImplemented();
	}

	public function set(name : String, value : Dynamic) : Void
	{
		throw new NotImplemented();
	}

	public function exists(name : String) : Bool
	{
		return throw new NotImplemented();
	}

	public function remove(name : String) : Void
	{
		throw new NotImplemented();
	}
}
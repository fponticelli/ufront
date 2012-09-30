/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web;

interface IHttpSessionState
{
	public function dispose() : Void;
	public function clear() : Void;
	public function get(name : String) : Dynamic;
	public function set(name : String, value : Dynamic) : Void;
	public function exists(name : String) : Bool;
	public function remove(name : String) : Void;
	public function id() : String;
	public function setLifeTime(lifetime:Int):Void;
}
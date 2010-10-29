package ufront.auth;

interface IAuthStorage<T> 
{
	public function isEmpty() : Bool;
	public function read() : T;
	public function write(contents : T) : Void;
	public function clear() : Void; 
}
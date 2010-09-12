package ufront.auth;

interface IAuthStorage 
{
	public function isEmpty() : Bool;
	public function read() : ?;
	public function write(contents : ?) : Void;
	public function clear() : Void; 
}
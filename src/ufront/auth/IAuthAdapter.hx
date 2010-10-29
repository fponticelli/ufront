package ufront.auth;

interface IAuthAdapter<T>
{
	public function authenticate() : AuthResult<T>;
}
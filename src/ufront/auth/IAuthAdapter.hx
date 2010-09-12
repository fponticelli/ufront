package ufront.auth;

interface IAuthAdapter 
{
	public function authenticate() AuthResult;
}
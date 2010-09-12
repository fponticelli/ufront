package ufront.auth;

class Auth
{
	public function new() 
	{
		
	}
	
	public function authenticate(adapter : IAuthAdapter) : AuthResult
	{
		
	} 
	       
	public function hasIdentity() : Bool
	{
		
	}   
	
	public function getIdentity() : ?
	{
		
	} 
	
	public function clearIdentity()
	{
		
	}
	
	public function setStorage(authstorage : IAuthStorage)
	{
		
	}
	   
	public function getStorage() : IAuthStorage
	{
		
	}
}
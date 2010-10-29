package ufront.auth;

class Auth<T>
{   
	var _storage : IAuthStorage<T>;
	
	public function new(?storage : IAuthStorage<T>) 
	{
		_storage = storage;
	}
	
	public function authenticate(adapter : IAuthAdapter<T>) : AuthResult<T>
	{
		var result = adapter.authenticate();
		
		if(hasIdentity())
			clearIdentity();
		if(result.isvalid)
			getStorage().write(result.identity);
		
		return result;
	} 
	       
	public function hasIdentity() : Bool
	{
		return !getStorage().isEmpty();
	}   
	
	public function getIdentity() : T
	{
		var storage = getStorage();
		if(storage.isEmpty())
			return null;
		return storage.read();
	} 
	
	public function clearIdentity()
	{
		getStorage().clear();
	}
	
	public function setStorage(authstorage : IAuthStorage<T>)
	{               
		_storage = authstorage;
		return this;
	}
	   
	public function getStorage() : IAuthStorage<T>
	{
		return _storage;
	}
}
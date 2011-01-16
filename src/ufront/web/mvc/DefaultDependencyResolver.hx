package ufront.web.mvc;
import thx.error.Error;

/**
 * ...
 * @author Andreas Soderlund
 */

class DefaultDependencyResolver implements IDependencyResolver
{
	public function new();
	
    public function getService<T>(type : Class<T>) : T
	{
		try
		{
			return Type.createInstance(type, []);
		}
		catch(e : Dynamic)
		{
			return null;
		}		
	}
}

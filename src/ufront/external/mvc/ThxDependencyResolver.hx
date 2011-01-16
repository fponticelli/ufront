package ufront.external.mvc;
import ufront.web.mvc.IDependencyResolver;
import thx.util.Injector;
import thx.error.NullArgument;

/**
 * ...
 * @author Franco Ponticelli
 */

class ThxDependencyResolver implements IDependencyResolver
{
	public var injector(default, null) : Injector;
	
	public function new(injector : Injector)
	{
		NullArgument.throwIfNull(injector, "injector");
		this.injector = injector;
	}
	
	public function getService<T>(serviceType:Class<T>):T 
	{
		return injector.get(serviceType);
	}
}
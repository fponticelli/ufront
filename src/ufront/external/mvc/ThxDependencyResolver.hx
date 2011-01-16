package ufront.external.mvc;
import ufront.web.mvc.DefaultDependencyResolver;
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
	public var defaultResolver : IDependencyResolver;
	
	public function new(injector : Injector)
	{
		NullArgument.throwIfNull(injector, "injector");
		this.injector = injector;
		this.defaultResolver = new DefaultDependencyResolver();
	}
	
	public function getService<T>(serviceType:Class<T>):T 
	{
		var o = injector.get(serviceType);
		if (null == o)
			return defaultResolver.getService(serviceType);
		else
			return o;
	}
}
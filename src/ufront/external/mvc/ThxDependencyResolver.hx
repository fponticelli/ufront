package ufront.external.mvc;
import ufront.web.mvc.DefaultDependencyResolver;
import ufront.web.mvc.IDependencyResolver;
import thx.type.Factory;
import thx.error.NullArgument;

/**
 * ...
 * @author Franco Ponticelli
 */

class ThxDependencyResolver implements IDependencyResolver
{
	public var factory(default, null) : Factory;
	public var defaultResolver : IDependencyResolver;
	
	public function new(factory : Factory)
	{
		NullArgument.throwIfNull(factory, "factory");
		this.factory = factory;
		this.defaultResolver = new DefaultDependencyResolver();
	}
	
	public function getService<T>(serviceType:Class<T>):T 
	{
		var o = factory.get(serviceType);
		if (null == o)
			return defaultResolver.getService(serviceType);
		else
			return o;
	}
}
package ufront.external.mvc;
import ufront.web.mvc.DefaultDependencyResolver;
import ufront.web.mvc.IDependencyResolver;
import thx.util.TypeLocator;
import thx.error.NullArgument;

/**
 * ...
 * @author Franco Ponticelli
 */

class ThxDependencyResolver implements IDependencyResolver
{
	public var locator(default, null) : TypeLocator;
	public var defaultResolver : IDependencyResolver;

	public function new(locator : TypeLocator)
	{
		NullArgument.throwIfNull(locator);
		this.locator = locator;
		this.defaultResolver = new DefaultDependencyResolver(this);
	}

	public function getService<T>(serviceType:Class<T>):T
	{
		var o = locator.get(serviceType);
		if (null == o)
			return defaultResolver.getService(serviceType);
		else
			return o;
	}
}
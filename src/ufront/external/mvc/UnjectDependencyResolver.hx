package ufront.external.mvc;

#if unject

import ufront.web.mvc.IDependencyResolver;
import unject.IKernel;
import unject.StandardKernel;
import unject.UnjectModule;
import thx.error.NullArgument;

/**
 * ...
 * @author Andreas Soderlund
 */

class UnjectDependencyResolver implements IDependencyResolver
{
	public var kernel(default, null) : IKernel;

	public function new(kernel : IKernel)
	{
		NullArgument.throwIfNull(kernel, "kernel");
		this.kernel = kernel;
	}

	public function getService<T>(serviceType:Class<T>):T
	{
		return kernel.get(serviceType);
	}
}
#end
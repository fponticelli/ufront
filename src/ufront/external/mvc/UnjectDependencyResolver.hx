package ufront.external.mvc;
import ufront.web.mvc.IDependencyResolver;
import unject.IKernel;
import unject.StandardKernel;
import unject.UnjectModule;

/**
 * ...
 * @author Andreas Soderlund
 */

class UnjectDependencyResolver implements IDependencyResolver
{
	public var kernel(default, null) : IKernel;
	
	public function new(kernel : IKernel)
	{
		this.kernel = kernel;
	}
	
	public function getService<T>(serviceType:Class<T>):T 
	{
		return kernel.get(serviceType);
	}
	
	public function getServices<T>(serviceType:Class<T>):Iterable<T>
	{
		return throw "Not implemented.";
	}	
}
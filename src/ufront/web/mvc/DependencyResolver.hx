package ufront.web.mvc;

/**
 * Provides a registration point for dependency resolvers that implement IDependencyResolver or the Common Service Locator IServiceLocator interface.
 * 
 * @author Andreas Soderlund
 */

class DependencyResolver 
{
	/** Gets or sets the implementation of the dependency resolver. */
	public static var current : IDependencyResolver = new DefaultDependencyResolver();
}

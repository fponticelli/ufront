package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

class DependencyResolver 
{
	public static var current : IDependencyResolver = new DefaultDependencyResolver();
}

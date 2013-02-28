package ufront.web.mvc;

/**
 * Defines the methods that simplify service location and dependency resolution. 
 * @author Andreas Soderlund
 */

interface IDependencyResolver 
{
    function getService<T>(serviceType : Class<T>) : T;
}

package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

interface IDependencyResolver 
{
    function getService<T>(serviceType : Class<T>) : T;
    function getServices<T>(serviceType : Class<T>) : Iterable<T>;
}

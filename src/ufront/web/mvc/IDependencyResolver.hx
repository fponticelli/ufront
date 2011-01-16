package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

interface IDependencyResolver 
{
    function getService<T>(serviceType : Class<T>) : T;
}

package ufront.web;
import ufront.web.HttpContext;

/** Selects the controller that will handle an HTTP request. 
*
* MVC includes the following handler types:
* 
*     MvcHandler. This handler is responsible for initiating the ASP.NET pipeline for an MVC application. It receives a Controller instance from the MVC controller factory; this controller handles further processing of the request. Note that even though MvcHandler implements IHttpHandler, it cannot be mapped as a handler (for example, to the .mvc file-name extension) because the class does not support a parameterless constructor. (Its only constructor requires a RequestContext object.)
* 
*     MvcRouteHandler. This class implements IRouteHandler, therefore it can integrate with ASP.NET routing. The MvcRouteHandler class associates the route with an MvcHandler instance. A MvcRouteHandler instance is registered with routing when you use the MapRoute method. When the MvcRouteHandler class is invoked, the class generates an MvcHandler instance using the current RequestContext instance. It then delegates control to the new MvcHandler instance.
* 
*     MvcHttpHandler. This handler is used to facilitate direct handler mapping without going through the routing module. This is useful if you want to map a file-name extension such as .mvc directly to an MVC handler. Internally, MvcHttpHandler performs the same tasks that ASP.NET routing ordinarily performs (going through MvcRouteHandler and MvcHandler). However, it performs these tasks as a handler instead of as a module. This handler is not typically used when the UrlRoutingModule is enabled for all requests.
*/
interface IHttpHandler {
	public function processRequest(context : HttpContext, async : hxevents.Async) : Void;
}
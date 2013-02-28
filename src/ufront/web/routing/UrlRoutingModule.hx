package ufront.web.routing;

import ufront.web.error.PageNotFoundError;
import ufront.web.HttpApplication;
import ufront.web.IHttpHandler;
import ufront.web.IHttpModule;

/**
 * Gets an IHttpHandler from the routing and executes it in the HttpApplication context.
 * Matches a URL request to a defined route. 
 * @author Andreas Soderlund
 */
class UrlRoutingModule implements IHttpModule
{
	/** Gets the collection of defined routes for the Ufront application. */
	public var routeCollection(default, null) : RouteCollection;

	var httpHandler : IHttpHandler;

	public function new(?routeCollection : RouteCollection)
	{
		this.routeCollection = (routeCollection != null) ? routeCollection : new RouteCollection();
	}

	/** Initializes a module and prepares it to handle requests. */
	public function init(application : HttpApplication) : Void
	{
		application.onPostResolveRequestCache.add(setHttpHandler);
		application.onPostMapRequestHandler.addAsync(executeHttpHandler);
	}

	function setHttpHandler(application : HttpApplication)
	{
		var httpContext = application.httpContext;

		for(route in routeCollection)
		{
			var data = route.getRouteData(httpContext);
			if (data == null) continue;

			var requestContext = new RequestContext(httpContext, data, routeCollection);
			httpHandler = data.routeHandler.getHttpHandler(requestContext);

			return;
		}

		throw new PageNotFoundError();
	}

	function executeHttpHandler(application : HttpApplication, async : hxevents.Async)
	{
		httpHandler.processRequest(application.httpContext, async);
	}

	/** Disposes of the resources (other than memory) that are used by the module. */
	public function dispose() : Void
	{
		routeCollection = null;
		httpHandler = null;
	}
}
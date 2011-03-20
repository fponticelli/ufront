package ufront.web.mvc;

import ufront.web.HttpApplication;
import ufront.web.HttpContext;
import ufront.web.PathInfoUrlFilter;
import ufront.web.routing.Route;
import ufront.web.routing.RouteBase;
import ufront.web.routing.RouteCollection;
import ufront.web.routing.UrlRoutingModule;
import ufront.web.AppConfiguration;
using thx.util.DynamicsT;

/**
 * ...
 * @author Andreas Soderlund
 */

class MvcApplication extends HttpApplication
{
	public static var defaultRoute : RouteBase = new Route(
		"/{controller}/{action}/{?id}", 
		new MvcRouteHandler(),
		{ controller: "Home", action: "index" }.toHash(),
		null
	);
	
	/**
	 * Initializes a new instance of the MvcApplication class.
	 * @param	?routes				 Routes for the application. If null, the default /{controller}/{action}/{?id} route will be used.
	 * @param	?controllerPackage	 Package for the controllers. If null, the current application package will be used.
	 * @param	?serverConfiguration Server-specific settings like mod_rewrite. If null, class defaults will be used.
	 * @param	?httpContext		 Context for the request, if null a web context will be created. Could be useful for unit testing.
	 */
	public function new(?configuration : AppConfiguration, ?routes : RouteCollection, ?httpContext : HttpContext)
	{
		if (configuration == null)
			configuration = new AppConfiguration();
		
		if (httpContext == null)
		{
			httpContext = HttpContext.createWebContext();

			// Unless mod_rewrite is used, filter out index.php/index.n from the urls.
			if(configuration.modRewrite != true)
				httpContext.addUrlFilter(new PathInfoUrlFilter());
		}
		
		super(httpContext);
		
		// Add a UrlRoutingModule to the application, to set up the routing.
		modules.add(new UrlRoutingModule(routes == null ? new RouteCollection([defaultRoute]) : routes));
		
		for (pack in configuration.controllerPackages)
		{
			ControllerBuilder.current.packages.add(pack);
		}
		
		for (pack in configuration.attributePackages)
		{
			ControllerBuilder.current.packages.add(pack);
		}
	}	
}
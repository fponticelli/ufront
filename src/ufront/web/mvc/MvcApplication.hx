package ufront.web.mvc;

import thx.collections.UHash;
import ufront.web.HttpApplication;
import ufront.web.HttpContext;
import ufront.web.PathInfoUrlFilter;
import ufront.web.routing.Route;
import ufront.web.routing.RouteBase;
import ufront.web.routing.RouteCollection;
import ufront.web.routing.UrlRoutingModule;
import ufront.web.ServerConfiguration;

/**
 * ...
 * @author Andreas Soderlund
 */

class MvcApplication extends HttpApplication
{
	public static var defaultRoute : RouteBase = new Route(
		"/{controller}/{action}/{?id}", 
		new MvcRouteHandler(),
		UHash.createHash({ controller: "Home", action: "index" }),
		null
	);
	
	/**
	 * Initializes a new instance of the MvcApplication class.
	 * @param	?routes				 Routes for the application. If null, the default /{controller}/{action}/{?id} route will be used.
	 * @param	?controllerPackage	 Package for the controllers. If null, the current application package will be used.
	 * @param	?serverConfiguration Server-specific settings like mod_rewrite. If null, class defaults will be used.
	 * @param	?httpContext		 Context for the request, if null a web context will be created. Could be useful for unit testing.
	 */
	public function new(?routes : RouteCollection, ?controllerPackage : String, ?serverConfiguration : ServerConfiguration, ?httpContext : HttpContext)
	{
		if (serverConfiguration == null)
			serverConfiguration = new ServerConfiguration();
		
		if (httpContext == null)
		{
			httpContext = HttpContext.createWebContext();

			// Unless mod_rewrite is used, filter out index.php/index.n from the urls.
			if(serverConfiguration.modRewrite != true)
				httpContext.addUrlFilter(new PathInfoUrlFilter());
		}
		
		super(httpContext);
		
		// Add a UrlRoutingModule to the application, to set up the routing.
		modules.add(new UrlRoutingModule(routes == null ? new RouteCollection([defaultRoute]) : routes));
		
		// If no controllerPackage is set, use the current class package.
		if (controllerPackage == null)
		{
			var className = Type.getClassName(Type.getClass(this));
			var packageName = className.substr(0, className.lastIndexOf("."));

			ControllerBuilder.current.addPackage(packageName);
		}
		else
			ControllerBuilder.current.addPackage(controllerPackage);
	}	
}
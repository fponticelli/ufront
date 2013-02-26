package ufront.web.mvc;

import ufront.web.DirectoryUrlFilter;
import ufront.web.HttpApplication;
import ufront.web.HttpContext;
import ufront.web.PathInfoUrlFilter;
import ufront.web.routing.Route;
import ufront.web.routing.RouteBase;
import ufront.web.routing.RouteCollection;
import ufront.web.routing.UrlRoutingModule;
import ufront.web.AppConfiguration;
import ufront.web.module.ErrorModule;
import ufront.web.module.ITraceModule;
import ufront.web.module.TraceToBrowserModule;
import ufront.web.module.TraceToFileModule;
import haxe.ds.StringMap;
using DynamicsT;

/**
 * ...
 * @author Andreas Soderlund
 * @author Franco Ponticelli
 */

class MvcApplication extends HttpApplication
{
	public static var defaultRoutes : Array<Route> = [
		new Route(
			"/",
			new MvcRouteHandler(),
			{ controller: "home", action: "index" }.toHash(), null
		), new Route(
			"/{controller}/{action}/{?id}",
			new MvcRouteHandler(), null, null
		)];

	public var routeModule(default, null) : UrlRoutingModule;

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

			// if base path is different from "/" than work in a subfolder
			var path = Strings.trim(configuration.basePath, "/");
			if (path.length > 0)
				httpContext.addUrlFilter(new DirectoryUrlFilter(path));

			// Unless mod_rewrite is used, filter out index.php/index.n from the urls.
			if(configuration.modRewrite != true)
				httpContext.addUrlFilter(new PathInfoUrlFilter());
		}

		super(httpContext);

		// Add a UrlRoutingModule to the application, to set up the routing.
		modules.add(routeModule = new UrlRoutingModule(routes == null ? new RouteCollection(defaultRoutes) : routes));

		for (pack in configuration.controllerPackages)
			ControllerBuilder.current.packages.add(pack);

		for (pack in configuration.attributePackages)
			ControllerBuilder.current.packages.add(pack);

		// add debugging modules
		modules.add(new ErrorModule());

		if(!configuration.disableBrowserTrace)
		{
			modules.add(new TraceToBrowserModule());
		}

		if(null != configuration.logFile)
		{
			modules.add(new TraceToFileModule(configuration.logFile));
		}

		var old = haxe.Log.trace;
		haxe.Log.trace = function(msg : Dynamic, ?pos : haxe.PosInfos)
		{
			var found = false;
			for(module in modules)
			{
				var tracer = Types.as(module, ITraceModule);
				if(null != tracer)
				{
					found = true;
					tracer.trace(msg, pos);
				}
			}
			if(!found)
				old(msg, pos);
		}
	}
}
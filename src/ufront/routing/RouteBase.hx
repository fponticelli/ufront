/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.routing;
import ufront.context.http.HttpContextBase;
import ufront.controller.RequestContext;

class RouteBase
{
	public function getData(context : HttpContextBase) : Hash<String>;
	public function getVirtualPath(requestContext : RequestContext, value : Hash<Dynamic>) : VirtualPathData;
}
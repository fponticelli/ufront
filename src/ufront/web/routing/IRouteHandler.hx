/**
 * ...
 * @author Franco Ponticelli
 */

package ufront.web.routing;
import ufront.web.IHttpHandler;
import ufront.web.routing.RequestContext;

interface IRouteHandler
{
	public function getHttpHandler(requestContext : RequestContext) : IHttpHandler;
}
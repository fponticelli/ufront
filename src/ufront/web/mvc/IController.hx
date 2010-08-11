package ufront.web.mvc;

import ufront.web.routing.RequestContext;

interface IController
{
	public function execute(requestContext : RequestContext) : Void;
}
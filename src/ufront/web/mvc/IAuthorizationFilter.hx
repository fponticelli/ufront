package ufront.web.mvc;

import hxevents.Dispatcher;

interface IAuthorizationFilter
{
	function onAuthorization(filterContext : AuthorizationContext) : Void; 
	//public var onFailedAuthorization(default, null) : Dispatcher<AuthorizationContext>;
}
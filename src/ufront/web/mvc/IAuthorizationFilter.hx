package ufront.web.mvc;

import hxevents.Dispatcher;

/** Defines the methods that are required for an authorization filter. */
interface IAuthorizationFilter
{
	function onAuthorization(filterContext : AuthorizationContext) : Void; 
	//public var onFailedAuthorization(default, null) : Dispatcher<AuthorizationContext>;
}
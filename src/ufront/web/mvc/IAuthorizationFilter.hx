package ufront.web.mvc;

import hxevents.Dispatcher;

interface IAuthorizationFilter
{
	public var onAuthorization(default, null) : Dispatcher<AuthorizationContext>; 
	public var onFailedAuthorization(default, null) : Dispatcher<AuthorizationContext>;
}
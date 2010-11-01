package ufront.web.mvc;

import hxevents.Dispatcher;

interface IAuthorizationFilter
{
	public var onAuthorization(default, null) : Dispatcher<AuthorizationContext>;
}
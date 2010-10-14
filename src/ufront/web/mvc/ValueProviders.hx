package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

// TODO: Remove singleton
class ValueProviders
{
	public static function providers(controllerContext : ControllerContext) : ValueProviderCollection 
	{
		return new ValueProviderCollection([
			cast(new FormValueProvider(controllerContext), IValueProvider), 
			cast(new RouteDataValueProvider(controllerContext), IValueProvider),
			cast(new QueryStringValueProvider(controllerContext), IValueProvider)
		]);
	}
}
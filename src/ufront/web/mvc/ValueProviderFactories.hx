package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

class ValueProviderFactories
{
	private static function __init__()
	{
		factories = new ValueProviderFactoryCollection([
			cast(new FormValueProviderFactory(), ValueProviderFactory), 
			cast(new RouteDataValueProviderFactory(), ValueProviderFactory),
			cast(new QueryStringValueProviderFactory(), ValueProviderFactory)
		]);
	}
		
	public static var factories : ValueProviderFactoryCollection;
}
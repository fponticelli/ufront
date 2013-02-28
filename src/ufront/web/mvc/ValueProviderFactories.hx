package ufront.web.mvc;

/**
 * Represents a container for value-provider factory objects. 
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
	
	/** Gets the collection of value-provider factories for the application. */
	public static var factories : ValueProviderFactoryCollection;
}
package ufront.web.routing;
import udo.collections.UHash;
import ufront.web.mvc.MvcRouteHandler;
import hxculture.ITranslation;
import ufront.web.routing.RoutesCollection;
import udo.error.NullArgument;
import ufront.web.routing.IRouteHandler;

class LocalizedRoute extends Route
{       
	public var translator(default, null) : ITranslation;
	public function new(translator : ITranslation, url : String, handler : IRouteHandler, ?defaults : Hash<String>, ?constraints : Array<IRouteConstraint>)
	{          
		super(url, handler, defaults, constraints);
		NullArgument.throwIfNull(translator, "translator");
		this.translator = translator;
	} 
	
	
	public static function addLocalizedRoute(collection : RoutesCollection, translator : ITranslation, uri : String, ?defaults : Dynamic<String>, ?constraints : Array<IRouteConstraint>)
	{
		collection.add(
	   		new LocalizedRoute( 
				translator,
		    	uri, 
				new MvcRouteHandler(),
				null == defaults ? null : UHash.createHash(defaults),
				constraints));
	}
}
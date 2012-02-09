package ufront.web.mvc;
import thx.error.Error;
import thx.type.Rttis;

/**
 * ...
 * @author Andreas Soderlund
 * @author Franco Ponticelli
 */

class DefaultDependencyResolver implements IDependencyResolver
{
	var alt : IDependencyResolver;
	public function new(?alt : IDependencyResolver)
	{
		this.alt = alt;
	}

    public function getService<T>(type : Class<T>) : T
	{
		try
		{
			var args = [];
			if(null != alt && Rttis.hasInfo(type))
			{
				var types = Rttis.methodArgumentTypes(type, "new");
				if(null != types)
				{
					for(type in types)
						args.push(alt.getService(Type.resolveClass(type)));
				}
			}
			return Type.createInstance(type, args);
		}
		catch(e : Dynamic)
		{
			return null;
		}
	}
}

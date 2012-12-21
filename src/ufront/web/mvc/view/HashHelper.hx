package ufront.web.mvc.view;

/**
 * ...
 * @author Franco Ponticelli
 */

class HashHelper implements IViewHelper
{
	public var hash(default, null) : Hash<Dynamic>;
	public function new(?dataHash : Hash<Dynamic>, ?dataObject : Dynamic)
	{
		hash = new Hash();
		if (null != dataHash)
		{
			for (key in dataHash.keys())
				hash.set(key, dataHash.get(key));
		}

		if (null != dataObject)
		{
			for (key in Reflect.fields(dataObject))
				hash.set(key, Reflect.field(dataObject, key));
		}
	}

	public function register(data : Hash<Dynamic>)
	{
		for (key in hash.keys())
			data.set(key, hash.get(key));
	}
}
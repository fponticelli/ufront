package ufront.web.mvc.view;

/**
 * ...
 * @author Franco Ponticelli
 */

import haxe.ds.StringMap;

class HashHelper implements IViewHelper
{
	public var hash(default, null) : StringMap<Dynamic>;
	public function new(?dataHash : StringMap<Dynamic>, ?dataObject : Dynamic)
	{
		hash = new StringMap();
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

	public function register(data : StringMap<Dynamic>)
	{
		for (key in hash.keys())
			data.set(key, hash.get(key));
	}
}
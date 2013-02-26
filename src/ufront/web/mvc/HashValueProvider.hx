package ufront.web.mvc;

import thx.collection.Set;
import ufront.web.mvc.ValueProviderResult;
import haxe.ds.StringMap;

/**
 * ...
 * @author Andreas Soderlund
 */

class HashValueProvider<T> implements IValueProvider
{
	var prefixes : Set<String>;
	var values : StringMap<ValueProviderResult>;

	public function new(collection : StringMap<T>)
	{
		prefixes = new Set<String>();
		values = new StringMap<ValueProviderResult>();

		addValues(collection);
	}

	function addValues(collection : StringMap<T>)
	{
		if (collection.iterator().hasNext())
			prefixes.add("");

		for (key in collection.keys())
		{
			for (prefix in ValueProviderUtil.getPrefixes(key))
				prefixes.add(prefix);

			var value = collection.get(key);
			values.set(key, new ValueProviderResult(value, Std.string(value)));
		}
	}

	public function containsPrefix(prefix : String) : Bool
	{
		return prefixes.exists(prefix);
	}

	public function getValue(key : String) : ValueProviderResult
 	{
		/*
		if (values.exists(key))
			trace("[" + Type.getClassName(Type.getClass(this)) + "] get " + key);
		else
			trace("[" + Type.getClassName(Type.getClass(this)) + "] didn't find " + key);
		*/

		return values.exists(key) ? values.get(key) : null;
	}

}
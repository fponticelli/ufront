package ufront.web.mvc;

import thx.collections.Set;
import ufront.web.mvc.ValueProviderResult;

/**
 * ...
 * @author Andreas Soderlund
 */

class HashValueProvider<T> implements IValueProvider
{
	var prefixes : Set<String>;
	var values : Hash<ValueProviderResult>;

	public function new(collection : Hash<T>) 
	{
		prefixes = new Set<String>();
		values = new Hash<ValueProviderResult>();
		
		addValues(collection);
	}
	
	function addValues(collection : Hash<T>)
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
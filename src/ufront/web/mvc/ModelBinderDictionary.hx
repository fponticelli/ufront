package ufront.web.mvc;

import haxe.ds.StringMap;

/**
 * Represents a class that contains all model binders for the application, listed by binder type.
 * @author Andreas Soderlund
 */

class ModelBinderDictionary
{
	/** Gets the number of elements in the model binder dictionary. */
	public var count(get, null) : Int;
	private function get_count() { return Lambda.count(_innerDictionary); }

	/** Gets or sets the default model binder. */
	public var defaultBinder(get, set) : IModelBinder;
	var _defaultBinder : IModelBinder;
	private function get_defaultBinder()
	{
		if (_defaultBinder == null)
			_defaultBinder = new DefaultModelBinder();

		return _defaultBinder;
	}
	private function set_defaultBinder(v : IModelBinder)
	{
		_defaultBinder = v;
		return _defaultBinder;
	}

	/** Gets a collection that contains the keys in the model binder dictionary. */
	public var keys(get, null) : Iterator<String>;
	private function get_keys() { return _innerDictionary.keys(); }

	/** Gets a collection that contains the values in the model binder dictionary. */
	public var values(get, null) : Iterator<IModelBinder>;
	private function get_values() { return _innerDictionary.iterator(); }

	/** Adds the specified item to the model binder dictionary using the specified key. */
	public function add(key : Dynamic, value : IModelBinder)
	{
		_innerDictionary.set(typeString(key), value);
	}

	/** Removes the element that has the specified key from the model binder dictionary. */
	public function remove(key : Dynamic)
	{
		_innerDictionary.remove(typeString(key));
	}

	/** Removes all items from the model binder dictionary. */
	public function clear()
	{
		// Create new instance instead?
		for (v in _innerDictionary.keys())
			_innerDictionary.remove(v);
	}

	/** Determines whether the model binder dictionary contains a specified value. */
	public function contains(item : IModelBinder)
	{
		return Lambda.exists(_innerDictionary, function(binder : IModelBinder) { return binder == item; } );
	}

	/** Determines whether the model binder dictionary contains an element that has the specified key. */
	public function containsKey(key : Dynamic)
	{
		return _innerDictionary.exists(typeString(key));
	}

	/** Retrieves the model binder for the specified type or optionally retrieves a fallback model binder. */
	public function getBinder(type : Dynamic, ?fallbackBinder : IModelBinder, ?fallbackToDefault = true) : IModelBinder
	{
		// Try to look up a binder for this type. We use this order of precedence:
		// 1. Binder registered in the global table
		// TODO: 2. Binder attribute defined on the type
		// 3. Supplied fallback binder

		if (containsKey(type)) return _innerDictionary.get(typeString(type));

		return fallbackBinder != null ? fallbackBinder : (fallbackToDefault ? defaultBinder : null);
	}

	function typeString(type : Dynamic) : String
	{
		if (Std.is(type, String)) return cast type;
		if (Std.is(type, Class)) return Type.getClassName(cast type);

		throw "Couldn't find a binder class for " + type;
	}

	/** Returns an iterator that can be used to iterate through the collection. */
	public function iterator()
	{
		return _innerDictionary.iterator();
	}

	var _innerDictionary : StringMap<IModelBinder>;

	public function new()
	{
		_innerDictionary = new StringMap<IModelBinder>();
	}
}
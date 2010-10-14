package ufront.web.mvc;

/**
 * ...
 * @author Andreas Soderlund
 */

class ModelBinderDictionary
{
	public var count(getCount, null) : Int;
	private function getCount() { return Lambda.count(_innerDictionary); }
	
	var _defaultBinder : IModelBinder;
	public var defaultBinder(getDefaultBinder, setDefaultBinder) : IModelBinder;
	private function getDefaultBinder()
	{ 
		if (_defaultBinder == null)
			_defaultBinder = new DefaultModelBinder();
		
		return _defaultBinder;
	}
	private function setDefaultBinder(v : IModelBinder)
	{
		_defaultBinder = v;
		return _defaultBinder;
	}
	
	public var keys(getKeys, null) : Iterator<String>;
	private function getKeys() { return _innerDictionary.keys(); }

	public var values(getValues, null) : Iterator<IModelBinder>;
	private function getValues() { return _innerDictionary.iterator(); }
	
	public function add(key : Dynamic, value : IModelBinder)
	{
		_innerDictionary.set(typeString(key), value);
	}
	
	public function remove(key : Dynamic)
	{
		_innerDictionary.remove(typeString(key));
	}
	
	public function clear()
	{
		// Create new instance instead?
		for (v in _innerDictionary.keys())
			_innerDictionary.remove(v);
	}

	public function contains(item : IModelBinder)
	{
		return Lambda.exists(_innerDictionary, function(binder : IModelBinder) { return binder == item; } );
	}
	
	public function containsKey(key : Dynamic)
	{
		return _innerDictionary.exists(typeString(key));
	}

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
	
	public function iterator()
	{
		return _innerDictionary.iterator();
	}
	
	var _innerDictionary : Hash<IModelBinder>;
	
	public function new() 
	{
		_innerDictionary = new Hash<IModelBinder>();
	}	
}
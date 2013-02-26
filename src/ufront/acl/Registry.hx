package ufront.acl;

import thx.collection.Set;
import thx.error.NullArgument;
import thx.error.Error;
import haxe.ds.StringMap;
using Iterators;

class Registry
{
	var _roles : StringMap<{ role : String, parents : Set<String>, children : Set<String> }>;
	public function new()
	{
		_roles = new StringMap();
	}

	public function add(role : String, ?parent : String, ?parents : Array<String>)
	{
		if(exists(role))
			throw new Error("Role {0} already exists in the registry", role);
		parents = _parents(parent, parents);

		var roleParents = new Set();
		for(parent in parents)
		{
			if(!exists(parent))
				throw new Error("Parent Role '{0}' does not exist", parent);
			roleParents.add(parent);
			_roles.get(parent).children.add(role);
		}

		_roles.set(role, {
			role     : role,
			parents  : roleParents,
			children : new Set()
		});
	}

	public function exists(role : String)
	{
		return _roles.exists(role);
	}

	public function getParents(role : String)
	{
		if(!_roles.exists(role))
			throw new Error("Role '{0}' does not exist in the registry", role);
		return _roles.get(role).parents.array();
	}

	public function getChildren(role : String)
	{
		if(!_roles.exists(role))
			throw new Error("Role '{0}' does not exist in the registry", role);
		return _roles.get(role).children.array();
	}

	public function inherits(role : String, inherit : String, onlyParents = false)
	{
		NullArgument.throwIfNull(role);
		NullArgument.throwIfNull(inherit);

	 	var r = _roles.get(role);
		if(null == r)
			throw new Error("Role '{0}' does not exist in the registry", role);

		var i = r.parents.exists(inherit);
		if(i || onlyParents)
			return i;

		for(parent in r.parents)
		{
			if(inherits(parent, inherit))
				return true;
		}
		return false;
	}

	public function remove(role : String)
	{
		var item = _roles.get(role);
		if(null == item)
			return false;

		for(child in item.children)
			_roles.get(child).parents.remove(role);
		for(parent in item.parents)
			_roles.get(parent).children.remove(role);
		_roles.remove(role);

		return true;
	}

	public function removeAll()
	{
		_roles = new StringMap();
	}

	public function iterator()
	{
		return _roles.keys();
	}

	static inline function _parents(parent : String, parents : Array<String>)
	{
		if(null == parents)
			parents = [];
		if(null != parent)
			parents.push(parent);
		return parents;
	}
}
package ufront.acl;

import haxe.ds.StringMap;

/**
*  @todo remove loops over keys for removal
*/

import thx.error.NullArgument;
import thx.error.Error;
import thx.collection.Set;
using Iterators;

typedef Combo = {
	type : AccessType,
	assert : Null<Acl -> String -> String -> String -> Bool>
}

class Acl
{
	var _registry : Registry;
	var _resources : StringMap<{
		resource : String,
		parent : String,
		children : Set<String>
	}>;
	var _rules : {
		allResources : {
			allRoles : {
				allPrivileges : Combo,
				byPrivilegeId : StringMap<Combo>
			},
			byRoleId : StringMap<{ byPrivilegeId : StringMap<Combo>, allPrivileges : Combo }>
		},
		byResourceId : StringMap<{
			allRoles : {
				allPrivileges : Combo,
				byPrivilegeId : StringMap<Combo>
			},
			byRoleId : StringMap<{ byPrivilegeId : StringMap<Combo>, allPrivileges : Combo }>
		}>
	};
	var _isAllowedRole : String;
	var _isAllowedResource : String;
	var _isAllowedPrivilege : String;
	
	public function new()
	{
		_registry = new Registry();
		_resources = new StringMap();
		_rules = {
			allResources : {
				allRoles : {
					allPrivileges : {
						type   : Deny,
						assert : null
					},
					byPrivilegeId : new StringMap()
				},
				byRoleId : new StringMap()
			},
			byResourceId : new StringMap()
		};
		_isAllowedPrivilege = null;
	}
	
	public function addRole(role : String, ?parent : String, ?parents : Array<String>)
	{
		_registry.add(role, parent, parents);
		return this;
	}
	
	public function getRoles()
	{
		return _registry.iterator();
	}
	
	public function existsRole(role : String)
	{
		return _registry.exists(role);
	}
	
	public function inheritsRole(role : String, inherit : String, ?onlyParents : Bool)
	{
		return _registry.inherits(role, inherit, onlyParents);
	}
	
	public function removeRole(role : String)
	{
		if(!_registry.remove(role))
			return false;

		for(key in _rules.allResources.byRoleId.keys())
		{
			if(role == key)
			{
				_rules.allResources.byRoleId.remove(key);
			}
		}

		for(key in _rules.byResourceId.keys())
		{
			var rules = _rules.byResourceId.get(key);
			for(r in rules.byRoleId.keys())
			{
				if(r == role)
					rules.byRoleId.remove(r);
			}
		}
		return true;
	}
	
	public function removeRoleAll()
	{
		_registry.removeAll();
		_rules = {
			allResources : {
				allRoles : {
					allPrivileges : {
						type   : Deny,
						assert : null
					},
					byPrivilegeId : new StringMap()
				},
				byRoleId : new StringMap()
			},
			byResourceId : new StringMap()
		};
		return this;
	}
	
	public function addResource(resource : String, ?parent : String)
	{
		NullArgument.throwIfNull(resource);
		if(existsResource(resource))
			throw new Error("Resource '{0}' already exists in the ACL", resource);
		if(null != parent)
		{
			if(!existsResource(parent))
				throw new Error("Parent resource '{0}' does not exist in the ACL", parent);
			_resources.get(parent).children.add(resource);
		}
		
		_resources.set(resource, {
			resource : resource,
			parent : parent,
			children : new Set()
		});
		return this;
	}
	
	public function existsResource(resource : String)
	{
		return _resources.exists(resource);
	}
	
	public function inheritsResource(resource : String, inherit : String, onlyParent = false)
	{
		NullArgument.throwIfNull(resource);
		NullArgument.throwIfNull(inherit);
	
	 	var r = _resources.get(resource);
		if(null == r)
			throw new Error("Resource '{0}' does not exist in the registry", resource);
		
		if(r.parent == inherit)
			return true;
		else if(onlyParent || null == r.parent)
			return false;
		
		var p = r.parent;
		while(null != p)
		{
			var r = _resources.get(p);
			if(r.parent == inherit)
				return true;
			p = r.parent;
		}
		return false;
	}

	public function removeResource(resource : String)
	{
		NullArgument.throwIfNull(resource);
		if(!existsResource(resource))
			return false;
	
		var removed = [resource];
		var p = _resources.get(resource);
		if(null != p.parent)
			_resources.get(p.parent).children.remove(resource);
		for(child in p.children)
	   	{
			removeResource(child);
			removed.push(child);
		}
		
		for(r in removed)
		{
			for(res in _rules.byResourceId.keys())
			{
				if(res == resource)
				{
					_rules.byResourceId.remove(res);
				}
			}
		}
		
		_resources.remove(resource);
		
		return true;
	}

	public function removeAll()
	{
    	for(resource in _resources.keys())
		{
	    	for(res in _rules.byResourceId.keys())
				if(res == resource)
					_rules.byResourceId.remove(res);
		}
		_resources = new StringMap();
	   	return this;
	}


	public function allow(roles : Array<String>, ?resources : Array<String>, ?privileges : Array<String>, ?assert : Acl -> String -> String -> String -> Bool)
	{
		return setRule(Add, Allow, roles, resources, privileges, assert);
	}
	
	public function deny(roles : Array<String>, ?resources : Array<String>, ?privileges : Array<String>, ?assert : Acl -> String -> String -> String -> Bool)
	{
		return setRule(Add, Deny, roles, resources, privileges, assert);
	}
	
	public function removeAllow(roles : Array<String>, ?resources : Array<String>, ?privileges : Array<String>, ?assert : Acl -> String -> String -> String -> Bool)
	{
		return setRule(Remove, Allow, roles, resources, privileges, assert);
	}
	
	public function removeDeny(roles : Array<String>, ?resources : Array<String>, ?privileges : Array<String>, ?assert : Acl -> String -> String -> String -> Bool)
	{
		return setRule(Remove, Deny, roles, resources, privileges, assert);
	}
	
	public function setRule(operation : Operation, type : AccessType, ?roles : Array<String>, ?resources : Array<String>, ?privileges : Array<String>, ?assert : Acl -> String -> String -> String -> Bool)
	{
		if(null == roles || roles.length == 0)
			roles = [null];
		if(null == resources || resources.length == 0)
			resources = [null];
		if(null == privileges)
			privileges = [];
		
		switch(operation)
		{
			case Add:
				for(resource in resources)
				{
					for(role in roles)
					{
						var rules = _getRules(resource, role, true);
						if(privileges.length == 0)
						{
							rules.allPrivileges = {
								type : type,
								assert : assert
							};
						} else {
							for(privilege in privileges)
							{
								rules.byPrivilegeId.set(privilege, {
									type : type,
									assert : assert
								});
							}
						}
					}
				}
			case Remove:
				for(resource in resources)
				{
					for(role in roles)
					{
						var rules = _getRules(resource, role);
						if(null == rules)
							continue;
						if(privileges.length == 0)
						{
							if(null == resource && null == role)
							{
								if(Type.enumEq(type, rules.allPrivileges.type))
								{
									rules.allPrivileges.type = Deny;
									rules.allPrivileges.assert = null;
									rules.byPrivilegeId = new StringMap();
								}
								continue;
							}
							
							if(Type.enumEq(type, rules.allPrivileges.type))
							{
								rules.allPrivileges.type = Deny;
								rules.allPrivileges.assert = null;
							}
						} else {
							for(privilege in privileges)
							{
								if(rules.byPrivilegeId.exists(privilege) && Type.enumEq(type, rules.byPrivilegeId.get(privilege).type))
								{
									rules.byPrivilegeId.remove(privilege);
								}
							}
						}
					}
				}
		}
		return this;
	}
	
	public function isAllowed(?role : String, ?resource : String, ?privilege : String)
	{
		_isAllowedPrivilege = null;
		_isAllowedRole = (null != role) ? role : null;
		_isAllowedResource = (null != resource) ? resource : null;
		
		if(null == privilege)
		{
			do {
				if(null != role)
				{
					var result = _roleDFSAllPrivileges(role, resource);
					if(null != result)
						return result;
				}
				
				var rules = _getRules(resource, null);
				if(null != rules)
				{
					for(privilege in rules.byPrivilegeId.keys())
					{
						if(Type.enumEq(Deny, _getRuleType(resource, null, privilege)))
							return false;
					}
					var type = _getRuleType(resource, null, null);
					if(null != type)
						return Type.enumEq(Allow, type);
				}
				resource = _resources.get(resource).parent;
			} while(true);
		} else {
			_isAllowedPrivilege = privilege;
			do {
				if(null != role)
				{
					var result = _roleDFSOnePrivilege(role, resource, privilege);
					if(null != result)
						return result;
				}
				
				var type = _getRuleType(resource, null, privilege);
				if(null != type)
				{
					return Type.enumEq(Allow, type);
				}
				type = _getRuleType(resource, null, null);
				if(null != type)
					return Type.enumEq(Allow, type);
				resource = _resources.get(resource).parent;
			} while(true);
		}
		return false;
	}
	
	function _roleDFSAllPrivileges(role : String, resource : String)
	{
        var dfs = {
            visited : new Set(),
            stack   : []
        };

		var result = _roleDFSVisitAllPrivileges(role, resource, dfs);
		if(null != result)
			return result;

        while (null != (role = dfs.stack.pop())) {
			if(!dfs.visited.exists(role))
			{
				var result = _roleDFSVisitAllPrivileges(role, resource, dfs);
				if(null != result)
					return result;
			}
        }

        return null;
    }
	
	function _roleDFSVisitAllPrivileges(role : String, resource: String, dfs) : Null<Bool>
    {
		var rules = _getRules(resource, role);
		if(null != rules)
		{
			for(privilege in rules.byPrivilegeId.keys())
			{
				if(Type.enumEq(Deny, _getRuleType(resource, role, privilege)))
					return false;
			}
			var type = _getRuleType(resource, role, null);
			if(null != type)
			{
				return Type.enumEq(Allow, type);
			}
		}
		dfs.visited.add(role);
		for(parent in _registry.getParents(role))
		{
			dfs.stack.push(parent);
		}

        return null;
    }

    function _roleDFSOnePrivilege(role : String, resource : String, privilege : String) : Null<Bool>
    {
		NullArgument.throwIfNull(privilege);

		var dfs = {
			visited : new Set(),
			stack : []
		};

		var result = _roleDFSVisitOnePrivilege(role, resource, privilege, dfs);
		if(null != result)
			return result;
		
		var r;
		while(null != (r = dfs.stack.pop()))
		{
			if(!dfs.visited.exists(r))
			{
				var result = _roleDFSVisitOnePrivilege(r, resource, privilege, dfs);
				if(null != result)
					return result;
			}
		}
		
		return null;
    }

    function _roleDFSVisitOnePrivilege(role : String, resource : String, privilege : String, dfs) : Null<Bool>
    {
        NullArgument.throwIfNull(privilege);

		var result = _getRuleType(resource, role, privilege);
		if(null != result)
			return Type.enumEq(Allow, result);
		result = _getRuleType(resource, role, null);
		if(null != result)
            return Type.enumEq(Allow, result);

		dfs.visited.add(role);
		
		for(parent in _registry.getParents(role))
		{
			dfs.stack.push(parent);
		}

        return null;
    }

    function _getRuleType(resource : String, role : String, privilege : String)
    {
		var rules = _getRules(resource, role);
		if(null == rules) // todo, can this ever happen?
			return null;

		var rule = null;

        if (null == privilege) {
			if(null != rules.allPrivileges)
				rule = rules.allPrivileges;
			else
				return null;
        } else if (!rules.byPrivilegeId.exists(privilege)) {
            return null;
        } else {
			rule = rules.byPrivilegeId.get(privilege);
        }

		var assertionValue = false;
        // check assertion first
        if (null != rule.assert) {
            assertionValue = rule.assert( this, role, resource, _isAllowedPrivilege);
        }

        if (null == rule.assert || assertionValue) {
            return rule.type;
        } else if (null != resource || null != role || null != privilege) {
            return null;
        } else if (Type.enumEq(Allow, rule.type)) {
            return Deny;
        } else {
            return Allow;
        }
    }

	function _getRules(resource : String, role : String, create = false)
	{
		var visitor = null;
		if(null == resource)
		{
			visitor = _rules.allResources;
		} else {
			if(!_rules.byResourceId.exists(resource))
			{
				if(!create)
					return null;
				_rules.byResourceId.set(resource,
					{
						byRoleId : new StringMap<{ byPrivilegeId : StringMap<Combo>, allPrivileges : Combo }>(),
						allRoles : {
							allPrivileges : null,
							byPrivilegeId : new StringMap()
						}
					});
			}
			visitor = _rules.byResourceId.get(resource);
		}
		
		if(null == role)
		{
			return visitor.allRoles;
		}
		
		if(!visitor.byRoleId.exists(role))
		{
			if(!create)
				return null;
			visitor.byRoleId.set(role, {
				byPrivilegeId : new StringMap<Combo>(),
				allPrivileges : null
			});
		}
		return visitor.byRoleId.get(role);
	}

	public function getResources()
	{
		return _resources.keys();
	}
}

enum AccessType
{
	Allow;
	Deny;
}

enum Operation
{
	Add;
	Remove;
}
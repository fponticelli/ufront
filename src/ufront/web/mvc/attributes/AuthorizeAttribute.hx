package ufront.web.mvc.attributes;
import ufront.web.error.UnauthorizedError;
import ufront.acl.Acl;
using thx.type.UType;

class AuthorizeAttribute extends FilterAttribute, implements IAuthorizationFilter
{
	public var acl : Acl;
	public var roles : Array<String>;
	public var users : Array<String>;
	public var currentRoles : Array<String>;
	public var currentUser : String;
	
	public function new(?acl : Acl)
	{
		super();
		this.acl = acl;
		trace(acl);
	}
	
	public function onAuthorization(e : AuthorizationContext)
	{   
		var cname = e.controllerContext.controller.fullName();
		if(!acl.existsResource(cname))
			acl.addResource(cname);
		
		for(role in roles)
		{
			if(!acl.existsRole(role))
				acl.addRole(role);
		}

		if(roles.length > 0)
			acl.allow(roles, [cname], [e.actionName]);
		
		if(!isAllowed(cname, e.actionName))
		{
			e.result = new HttpUnauthorizedResult();
		}
	}
	
	function isAllowed(resource : String, privilege : String)
	{
		if(Lambda.has(users, currentUser))
			return true;
		for(role in currentRoles)
		{  
			if(acl.existsRole(role) && acl.isAllowed(role, resource, privilege))
				return true;
		}
		return false;
	}
}
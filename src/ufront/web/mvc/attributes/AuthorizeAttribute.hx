package ufront.web.mvc.attributes;
import ufront.web.error.UnauthorizedError;
import ufront.acl.Acl;
using Types;

/** Represents an attribute that is used to restrict access by callers to an action method. */
class AuthorizeAttribute extends FilterAttribute implements IAuthorizationFilter
{
	public var acl : Acl;

	/** Gets or sets the user roles. */
	public var roles : Array<String>;

	/** Gets or sets the authorized users. */
	public var users : Array<String>;
	
	public var currentRoles : Array<String>;
	public var currentUser : String;

	public function new()
	{
		super();
		roles = [];
		users = [];
		currentRoles = [];
		currentUser = null;
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
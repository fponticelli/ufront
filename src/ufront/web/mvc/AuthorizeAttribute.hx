package ufront.web.mvc;
import ufront.web.error.UnauthorizedError;
import ufront.acl.Acl;
using thx.type.UType;

class AuthorizeAttribute extends FilterAttribute
{
	public var roles : Array<String>;
	public var users : Array<String>;
	public var acl : Acl;
	public var currentRoles : Array<String>;
	public var currentUser : String;
	
	override function connect(controller : IController)
	{   
		controller.onAuthorization.add(authorize);
	}                                            
	
	function authorize(e : AuthorizationContext)
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
			if(!e.controllerContext.controller.onFailedAuthorization.has())
				throw new UnauthorizedError();
			else
				e.controllerContext.controller.onFailedAuthorization.dispatch(e);
			/*
			e.controllerContext.response.setUnauthorized();
			e.result = "Unauthorized access";              
			*/
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
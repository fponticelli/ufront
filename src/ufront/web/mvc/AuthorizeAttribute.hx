package ufront.web.mvc;
import ufront.acl.Acl;
using thx.type.UType;

class AuthorizeAttribute extends FilterAttribute
{
	public var groups : Array<String>;
	public var users : Array<String>;
	public var acl : Acl;
	
	public var currentRoles : Array<String>;
	
	override function connect(controller : IController)
	{  
		controller.onAuthorization.add(authorize);
	}                                            
	
	function authorize(e : AuthorizationContext)
	{
		var cname = e.controllerContext.controller.fullName();
		if(!acl.existsResource(cname))
			acl.addResource(cname);
		
		var roles = [];
		for(group in groups)
		{                                      
			var role = "group:" + group;
			roles.push(role);
			if(!acl.existsRole(role))
				acl.addRole(role);
		}
		
		for(user in users)
		{   
			var role = "user:" + user; 
			roles.push(role);
			if(!acl.existsRole(role))
				acl.addRole(role);
		}                                     
		
		if(roles.length > 0)
			acl.allow(roles, [cname], [e.actionName]);
		
		if(!isAllowed(cname, e.actionName))
		{
			e.controllerContext.response.setUnauthorized();
			e.result = "Unauthorized access";
		}
	}
	
	function isAllowed(resource : String, privilege : String)
	{
		for(role in currentRoles)
		{	
			if(acl.isAllowed(role, resource, privilege))
			{
				return true;
			}
		}
		return false;
	}
}
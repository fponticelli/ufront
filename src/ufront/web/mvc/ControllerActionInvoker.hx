package ufront.web.mvc;
import thx.collections.HashList;
import ufront.web.error.PageNotFoundError;

import ufront.web.mvc.ActionResult;
import thx.type.UType;
import thx.error.Error;
import thx.type.URtti;
import ufront.web.mvc.ControllerContext;
import haxe.rtti.CType;         
import thx.collections.Set;

using thx.collections.UIterable;  

class ControllerActionInvoker implements IActionInvoker
{                               
	public function new(binders : ModelBinderDictionary)
	{
		this.binders = binders;
	} 
	
	public var binders : ModelBinderDictionary;
	public var valueProvider : IValueProvider;
	
//	public var error(default, null) : Error;   
	
	function getParameterValue(controllerContext : ControllerContext, parameter : ParameterDescriptor) : Dynamic
	{
		var binder = getModelBinder(parameter);
				
		var bindingContext = new ModelBindingContext(
			parameter.name, 
			parameter.type,
			controllerContext.controller.valueProvider,
			parameter.ctype
		);
		
		return binder.bindModel(controllerContext, bindingContext);
	}
	
	function getModelBinder(parameter : ParameterDescriptor)
	{
		// TODO: Look on the parameter itself, then look in binders.
		return binders.getBinder(parameter.type);
	}
	
	function getParameters(controllerContext : ControllerContext, argsinfo : Array<{t: CType, opt: Bool, name: String}>) : HashList<Dynamic>
	{
		// TODO: ActionDescriptor, ControllerDescriptor
		// TODO: Filters
		
		var arguments = new HashList<Dynamic>();
		
		for(info in argsinfo)
		{
			// URtti.typeName is always called with false since the ValueProviderResult doesn't care about nullable.
			var parameter = new ParameterDescriptor(info.name, URtti.typeName(info.t, false), info.t);
			var value = getParameterValue(controllerContext, parameter);
			
			if(null == value)
			{          
				if(URtti.argumentAcceptNull(info))
				{
					arguments.set(info.name, null);
				}
				else
				{
					throw new Error("argument {0} cannot be null", info.name);
				}
			}
			else
			{
				arguments.set(info.name, value);
			}
		}
		
		return arguments;
	}
	
	static function isAsync(method)
	{
		var arguments = URtti.methodArguments(method);
		if(0 == arguments.length)
			return false;
		var last = arguments.pop();
		return switch(last.t)
		{
			case CFunction(args, ret): 
				if(args.length != 1)
					false;
			    switch(ret) 
				{
					case CEnum(t, _):
						t == "Void";
					default:
						false;
				}
			default: false;
		}
	}
	
	public function invokeAction(controllerContext : ControllerContext, actionName : String, async : hxevents.Async) : Void
	{      
//		error = null; 
		
		var controller = controllerContext.controller;
		var fields = URtti.getClassFields(Type.getClass(controller));
		var method = fields.get(actionName); 
		var arguments : HashList<Dynamic>;
		var isasync = isAsync(method); 
		try
		{
			if(null == method)
				throw new Error("action {0} does not exist on this controller", actionName);

			if(!method.isPublic)
				throw new Error("action {0} must be a public method", actionName);
			   
			var argsinfo = URtti.methodArguments(method);
			if(isasync)
			{
				argsinfo.pop();
			}
			if(null == argsinfo)
				throw new Error("action {0} is not a method", actionName); 

			arguments = getParameters(controllerContext, argsinfo);
		}
		catch (e : Error)
		{   
			_handleUnknownAction(actionName, async, e);
			return;
		}
		
		var action = actionName;
#if php
    	if(_mapper.exists(actionName))
			action = "h" + actionName;
#end
        var authorizationContext = new AuthorizationContext(controllerContext, actionName, arguments);
		controllerContext.controller.onAuthorization.dispatch(authorizationContext);
		if(null != authorizationContext.result)
		{
			processContent(authorizationContext.result, controllerContext, async);
		} else {
			var executingContext = new ActionExecutingContext(controllerContext, actionName, arguments);
			controllerContext.controller.onActionExecuting.dispatch(executingContext);
			if(null != executingContext.result)
			{
				processContent(executingContext.result, controllerContext, async);
			} else if(isasync) {
			 	var handler = function(value) {
					var executedContext = new ActionExecutedContext(controllerContext, actionName, value);
					controllerContext.controller.onActionExecuted.dispatch(executedContext);
				
					processContent(executedContext.result, controllerContext, async);
				};
				var args = arguments.array();
				args.push(handler);
				Reflect.callMethod(controller, Reflect.field(controller, action), args);
			} else {
				var value = Reflect.callMethod(controller, Reflect.field(controller, action), arguments.array());
			
				var executedContext = new ActionExecutedContext(controllerContext, actionName, value);
				controllerContext.controller.onActionExecuted.dispatch(executedContext);
				processContent(executedContext.result, controllerContext, async);
			}    
		}
	}
	
	static function processContent(value : Dynamic, controllerContext : ControllerContext, async : hxevents.Async)
	{   
		var executingContext = new ResultExecutingContext(controllerContext, value);
		controllerContext.controller.onResultExecuting.dispatch(executingContext);
		value = executingContext.result;
		if(null != value && Std.is(value, ActionResult))
		{
			var result : ActionResult = cast value;    
			result.executeResult(controllerContext);
		}
		else if(value != null && controllerContext != null && controllerContext.response != null)
		{
			// Write the returnValue to response.
			controllerContext.response.write(Std.string(value));
		}
		var executedContext = new ResultExecutedContext(controllerContext, value);
		controllerContext.controller.onResultExecuted.dispatch(executedContext);
		async.completed(); 
	}
	
	function _handleUnknownAction(action : String, async : hxevents.Async, err : Dynamic)
	{    
		var error = new PageNotFoundError();
		if (Std.is(err, Error))
		{
			error.setInner(err);
		} else {
			error.setInner(new Error("action can't be executed because {0}", Std.string(err)));
		}   		
		async.error(error);
	}
		
#if php
	static var _mapper : Set<String>; 
    static function __init__()
	{
		_mapper = new Set();
		_mapper.add("and");
		_mapper.add("or");
		_mapper.add("xor");
		_mapper.add("exception");
		_mapper.add("array");
		_mapper.add("as");
		_mapper.add("const");
		_mapper.add("declare");
		_mapper.add("die");
		_mapper.add("echo");
		_mapper.add("elseif");
		_mapper.add("empty");
		_mapper.add("enddeclare");
		_mapper.add("endfor");
		_mapper.add("endforeach");
		_mapper.add("endif");
		_mapper.add("endswitch");
		_mapper.add("endwhile");
		_mapper.add("eval");
		_mapper.add("exit");
		_mapper.add("foreach");
		_mapper.add("global");
		_mapper.add("include");
		_mapper.add("include_once");
		_mapper.add("isset");
		_mapper.add("list");
		_mapper.add("print");
		_mapper.add("require");
		_mapper.add("require_once");
		_mapper.add("unset");
		_mapper.add("use");
		_mapper.add("final");
		_mapper.add("php_user_filter");
		_mapper.add("protected");
		_mapper.add("abstract");
		_mapper.add("__set");
		_mapper.add("__get");
		_mapper.add("__call");
		_mapper.add("clone"); 
	}
#end
}
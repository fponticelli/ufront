package ufront.web.mvc;
import haxe.rtti.Meta;
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
	public function new(binders : ModelBinderDictionary, controllerBuilder : ControllerBuilder)
	{
		this.binders = binders;
		this.controllerBuilder = controllerBuilder;
	} 
	
	public var controllerBuilder : ControllerBuilder;
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
		var filterInfo = getFilters(controllerContext, action);		
		mergeControllerFilters(cast controller, filterInfo);
		
		try
		{
			var authorizationContext = new AuthorizationContext(controllerContext, actionName, arguments);
			for (filter in filterInfo.authorizationFilters)
			{
				filter.onAuthorization(authorizationContext);
			}
			
			//trace(Type.getClassName(Type.getClass(authorizationContext.result)));
						
			if(null != authorizationContext.result)
			{
				// No other filters should be called if an authorizationFilter is
				// short-circuting the request.
				authorizationContext.result.executeResult(controllerContext);
			} 
			else 
			{
				var executingContext = new ActionExecutingContext(controllerContext, actionName, arguments);
				for (filter in filterInfo.actionFilters)
				{
					filter.onActionExecuting(executingContext);
				}
				
				var value = createActionResult(Reflect.callMethod(controller, Reflect.field(controller, action), arguments.array()));

				var executedContext = new ActionExecutedContext(controllerContext, actionName, value);				
				for (filter in reverse(filterInfo.actionFilters))
				{
					filter.onActionExecuted(executedContext);
				}

				processContent(value, controllerContext, filterInfo);
			}
		}
		catch(e : Dynamic)
		{
			
		}
		
		async.completed();
	}
	
	public static function createActionResult(actionReturnValue : Dynamic) : ActionResult
	{
		if (actionReturnValue == null)
			return new EmptyResult();
			
		if (Std.is(actionReturnValue, ActionResult)) return cast actionReturnValue;
		return new ContentResult(Std.string(actionReturnValue), null);
	}
	
	function reverse<T>(list : Array<T>)
	{
		var output = new Array<T>();
		for(i in list) { output.push(i); }
		return output; 
	}
	
	function processContent(value : ActionResult, controllerContext : ControllerContext, filters : FilterInfo)
	{
		var executingContext = new ResultExecutingContext(controllerContext, value);		
		for (filter in filters.resultFilters)
		{
			filter.onResultExecuting(executingContext);
		}
		
		value.executeResult(controllerContext);

		var executedContext = new ResultExecutedContext(controllerContext, value);
		for (filter in filters.resultFilters)
		{
			filter.onResultExecuted(executedContext);
		}
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
	
	function getFilters(context : ControllerContext, actionField : String) : FilterInfo
	{
		var array = new Array<FilterAttribute>();
		var attribute = getFieldAttributes(context.controller, actionField);
		
		if (attribute != null)
		{
			for (attributeClassName in Reflect.fields(attribute))
			{
				var c = getAttributeClass(attributeClassName);
				if (c == null) throw new Error('Attribute ' + attributeClassName + ' not found.');
				
				var obj = Type.createInstance(c, []);
				if (!Std.is(obj, FilterAttribute))
					throw new Error('Attribute ' + attributeClassName + ' does not inherit from FilterAttribute.');
					
				array.push(cast obj);
			}			
		}
		
		array.sort(function(x, y) { return x.order - y.order; } );
		
		return addFilters(array);
	}
	
	function addFilters(filters : Array<FilterAttribute>) : FilterInfo
	{
		var output = new FilterInfo();
		for (filter in filters)
		{
			addFilter(filter, output);
		}
		return output;
	}
	
	function getAttributeClass(className : String) : Class<Dynamic>
	{
		for (pack in controllerBuilder.attributes)
		{
			var c = Type.resolveClass(pack + '.' + className + 'Attribute');
			if (c != null) return c;
		}
		
		return null;
	}
	
	function getFieldAttributes(object : Dynamic, field : String) : Dynamic
	{
		var metadata = Meta.getFields(Type.getClass(object));
		return Reflect.field(metadata, field);
	}

	private function addFilter(attribute : FilterAttribute, filterInfo : FilterInfo) : Void 
	{
		if (Std.is(attribute, IAuthorizationFilter))
			filterInfo.authorizationFilters.push(cast attribute);
			
		if (Std.is(attribute, IActionFilter))
			filterInfo.actionFilters.push(cast attribute);
			
		if (Std.is(attribute, IResultFilter))
			filterInfo.resultFilters.push(cast attribute);
			
		if (Std.is(attribute, IExceptionFilter))
			filterInfo.exceptionFilters.push(cast attribute);
	}
	
	private function mergeControllerFilters(controller : ControllerBase, filterInfo : FilterInfo) : Void 
	{
		if (Std.is(controller, IAuthorizationFilter))
			filterInfo.authorizationFilters.unshift(cast controller);
			
		if (Std.is(controller, IActionFilter))
			filterInfo.actionFilters.unshift(cast controller);

		if (Std.is(controller, IResultFilter))
			filterInfo.resultFilters.unshift(cast controller);

		if (Std.is(controller, IExceptionFilter))
			filterInfo.exceptionFilters.unshift(cast controller);
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
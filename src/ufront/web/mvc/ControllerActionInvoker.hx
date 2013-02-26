package ufront.web.mvc;
import haxe.rtti.Meta;
import thx.collection.HashList;
import ufront.web.error.PageNotFoundError;

import ufront.web.mvc.attributes.FilterAttribute;
import ufront.web.mvc.ActionResult;
import thx.error.Error;
import thx.type.Rttis;
import ufront.web.mvc.ControllerContext;
import haxe.rtti.CType;
import thx.collection.Set;
import haxe.ds.StringMap;
using Strings;
using Iterables;

class ControllerActionInvoker implements IActionInvoker
{

	public function new(binders : ModelBinderDictionary, controllerBuilder : ControllerBuilder, dependencyResolver : IDependencyResolver)
	{
		this.binders = binders;
		this.controllerBuilder = controllerBuilder;
		this.dependencyResolver = dependencyResolver;
	}

	public var controllerBuilder : ControllerBuilder;
	public var binders : ModelBinderDictionary;
	public var valueProvider : IValueProvider;
	public var dependencyResolver : IDependencyResolver;

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

	function getParameters(controllerContext : ControllerContext, argsinfo : Array<{t: CType, opt: Bool, name: String}>, typeParameters : StringMap<CType>) : HashList<Dynamic>
	{
		// TODO: ActionDescriptor, ControllerDescriptor
		var arguments = new HashList<Dynamic>();

		for(info in argsinfo)
		{
			// Rttis.typeName is always called with false since the ValueProviderResult doesn't care about nullable.
			var tname = Rttis.typeName(info.t, false);
			var t = info.t;
			if (typeParameters.exists(tname))
			{
				t = typeParameters.get(tname);
				tname = Rttis.typeName(t, false);
			}
			var parameter = new ParameterDescriptor(info.name, tname, t);
			var value = getParameterValue(controllerContext, parameter);
			if(null == value)
			{
				if(Rttis.argumentAcceptNull(info))
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
		var arguments = Rttis.methodArguments(method);
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
		var controller = controllerContext.controller;
		var cls = Type.getClass(controller);
		var fields = Rttis.getClassFields(cls);
		var method = fields.get(actionName);
		var arguments : HashList<Dynamic>;
		var isasync = isAsync(method);

		try
		{
			if(null == method)
				throw new Error("action {0} does not exist on this controller", actionName);

			if(!method.isPublic)
				throw new Error("action {0} must be a public method", actionName);

			var argsinfo = Rttis.methodArguments(method);
			if(null == argsinfo)
				throw new Error("action {0} is not a method", actionName);

			if(isasync)
				argsinfo.pop();
			arguments = getParameters(controllerContext, argsinfo, Rttis.typeParametersMap(cls));
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
		try
		{
			var authorizationContext = new AuthorizationContext(controllerContext, actionName, arguments);
			for (filter in filterInfo.authorizationFilters)
				filter.onAuthorization(authorizationContext);

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

				if (null != executingContext.result || !isasync)
				{
					if (null == executingContext.result)
						executingContext.result = Reflect.callMethod(controller, Reflect.field(controller, action), arguments.array());
					var value = createActionResult(executingContext.result);

					var executedContext = new ActionExecutedContext(controllerContext, actionName, value);
					for (filter in reverse(filterInfo.actionFilters))
					{
						filter.onActionExecuted(executedContext);
					}
					processContent(value, controllerContext, filterInfo);
					async.completed();
				} else {
					var me = this;
					var handler = function(value) {
						var executedContext = new ActionExecutedContext(controllerContext, actionName, createActionResult(value));
						for (filter in reverse(filterInfo.actionFilters))
						{
							filter.onActionExecuted(executedContext);
						}
						me.processContent(value, controllerContext, filterInfo);
						async.completed();
					}
					var args = arguments.array();
					args.push(handler);
					Reflect.callMethod(controller, Reflect.field(controller, action), args);
				}
			}
		}
		catch(e : Dynamic)
		{
			var exceptionContext = new ExceptionContext(controllerContext, e);
			for (filter in filterInfo.exceptionFilters)
			{
				filter.onException(exceptionContext);
			}

			if (exceptionContext.exceptionHandled != true)
				throw e;

			createActionResult(exceptionContext.result).executeResult(controllerContext);
		}
	}

	function handleExecution(value : Dynamic)
	{

	}

	function processContent(result : ActionResult, controllerContext : ControllerContext, filters : FilterInfo)
	{
		var executingContext = new ResultExecutingContext(controllerContext, result);
		for (filter in filters.resultFilters)
		{
			filter.onResultExecuting(executingContext);
		}

		result.executeResult(controllerContext);

		var executedContext = new ResultExecutedContext(controllerContext, result);
		for (filter in reverse(filters.resultFilters))
		{
			filter.onResultExecuted(executedContext);
		}
	}

	///// Attribute filters /////////////////////////////////////////

	function getFilters(context : ControllerContext, actionField : String) : FilterInfo
	{
		var attributes = getAttributes(context.controller, actionField);
		attributes.sort(function(x, y) { return x.order - y.order; } );

		var output = new FilterInfo(attributes);

		// Add controller filters to beginning of output, if they exist.
		output.mergeControllerFilters(context.controller);
		return output;
	}

	function getAttributes(controller : ControllerBase, actionField : String) : Array<FilterAttribute>
	{
		// Get metadata from all controller classes
		var classes = createClassTree(Type.getClass(controller));
		var metadata = Lambda.map(classes, function(c) { return Meta.getType(c); } );

		// Append the action's field metadata last so it will have highest precedence.
		metadata.add(getFieldAttributes(controller, actionField));

		// Create a hash that will store all attributes and their arguments
		var hash = Lambda.fold(metadata, function(meta : Dynamic, output : StringMap<Dynamic>) {
			if (meta == null) return output;
			//trace(meta);
			for (className in Reflect.fields(meta))
			{
				var field = Reflect.field(meta, className);
				//trace(field);

				// We only care about the first array element, since it's like a
				// configuration object for the filter class (property injection)
				if (!Std.is(field, Array))
					output.set(className, null);
				else
					output.set(className, field[0]);
			}

			return output;
		}, new StringMap<Dynamic>());

		//trace(hash);

		// Map all valid attributes (exists in ControllerBuilder and ends with 'Attribute' to an object.
		var self = this;
		var objects = Lambda.map({ iterator: function() return hash.keys() }, function(key) {
			var c = self.getAttributeClass(key);
			if (c == null) return null;

			var instance = self.dependencyResolver.getService(c);
			var args = hash.get(key);

			//trace('Creating ' + Type.getClassName(c));

			// Filters require public properties to be configured properly.
			for(arg in Reflect.fields(args))
			{
				if (!Reflect.hasField(instance, arg))
					throw new Error("Filter " + Type.getClassName(Type.getClass(instance)) + " has no field " + arg);

				//trace("Setting " + Type.getClassName(c) + "." + arg + " to " + Reflect.field(args, arg));
				Reflect.setField(instance, arg, Reflect.field(args, arg));
			}

			return instance;
		});

		//trace(objects);

		// Filter out all non-created objects (null) and return
		return Lambda.array(Lambda.filter(objects, function(o) { return o != null; } ));
	}

	function createClassTree(cls : Class<Dynamic>, ?array : Array<Class<Dynamic>>) : Array<Class<Dynamic>>
	{
		if (array == null)
			array = new Array<Class<Dynamic>>();

		array.unshift(cls);

		var superClass = Type.getSuperClass(cls);
		return superClass != null ? createClassTree(superClass, array) : array;
	}

	function getAttributeClass(className : String) : Class<Dynamic>
	{
		for (pack in controllerBuilder.attributes)
		{
			var c = Type.resolveClass(pack + '.' + className.ucfirst() + 'Attribute');
			if (c != null && inheritsFrom(c, FilterAttribute)) return c;
		}

		return null;
	}

	function getFieldAttributes(object : Dynamic, field : String) : Dynamic
	{
		var metadata = Meta.getFields(Type.getClass(object));
		return Reflect.field(metadata, field);
	}

	function inheritsFrom(c : Class<Dynamic>, superClass : Class<Dynamic>)
	{
		var parent = Type.getSuperClass(c);

		if (parent == superClass) return true;
		return parent == null ? false : inheritsFrom(parent, superClass);
	}

	///// Action handler methods ////////////////////////////////////

	public static function createActionResult(actionReturnValue : Dynamic) : ActionResult
	{
		if (actionReturnValue == null)
			return new EmptyResult();

		if (Std.is(actionReturnValue, ActionResult)) return cast actionReturnValue;
		return new ContentResult(Std.string(actionReturnValue), null);
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

	///// Other /////////////////////////////////////////////////////

	static function reverse<T>(list : Array<T>)
	{
		var output = list.copy();
		output.reverse();
		return output;
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
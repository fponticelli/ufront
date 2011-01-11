package ufront.web.mvc;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
#else
import thx.error.NullArgument;
#end

class ControllerBuilder 
{
#if !macro
	public static var current = new ControllerBuilder();
	
	public var packages(default, null) : List<String>;
	public var attributes(default, null) : List<String>;
	
	public var controllerFactory(getControllerFactory, setControllerFactory) : IControllerFactory;
	var _controllerFactory : IControllerFactory;
	
	public function new()
	{
		packages = new List();
		attributes = new List();
		
		setControllerFactory(new DefaultControllerFactory(this, new DefaultDependencyResolver()));
	}
	
	public function getControllerFactory() : IControllerFactory
	{
		return _controllerFactory;
	}
	
	public function setControllerFactory(controllerFactory : IControllerFactory)
	{
		NullArgument.throwIfNull(controllerFactory, "controllerFactory");
		this._controllerFactory = controllerFactory;
		
		return controllerFactory;
	}	
#end

	@:macro public static function includePackage(pack : Expr)
	{
		switch(pack.expr)
		{
			case EConst(c):
				switch(c)
				{
					case CString(s):
						Compiler.include(s, false);
					default:
						//
				}
			default:
				//
		}
		
		return { expr: EConst(CType("Void")), pos: Context.currentPos() };
	}
}
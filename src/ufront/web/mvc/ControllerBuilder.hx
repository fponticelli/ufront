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
	
	var _packs : List<String>;
	var _controllerFactory : IControllerFactory;
	public function new()
	{
		_packs = new List();
		_controllerFactory = new DefaultControllerFactory(this);
	}
	
	public function getControllerFactory() : IControllerFactory
	{
		return _controllerFactory;
	}
	
	public function setControllerFactory(controllerFactory : IControllerFactory)
	{
		NullArgument.throwIfNull(controllerFactory, "controllerFactory");
		this._controllerFactory = controllerFactory;
	}
	
	public function addPackage(pack : String)
	{
		_packs.add(pack);
		ControllerBuilder.includePackage(pack);
	}
	
	public function packages()
	{
		return _packs.iterator();
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